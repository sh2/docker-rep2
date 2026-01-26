# docker-rep2

## 概要

以下のソフトのdockerコンテナを作成するDockerfileとdocker-compose.ymlです。
[pen/docker-rep2](https://github.com/pen/docker-rep2)のフォークです。

* rep2
* 2chproxy.pl
* caddy + PHP 他

## 使い方

git, docker, docker composeなどが必要です。

そのままの設定で使うなら以下を実行すればコンテナをビルドして起動までしてくれます。
標準ではポート番号は10088です。
変更したい場合はdocker-compose.ymlを編集してください。

```shell
git clone https://github.com/fukumen/docker-rep2.git
cd docker-rep2
docker compose up -d --build
```

標準ではカレントディレクトリのrep2-dataにrep2/dataの中身が格納されます。
変更したい場合はdocker-compose.ymlを編集してください。

### 2chproxy.plを使う場合(デフォルト)

rep2を以下の設定で使う想定です。

```
proxy_use: する
proxy_host: 127.0.0.1
proxy_port: 8080
2ch_ssl.subject: しない
2ch_ssl.post: しない
```

2ch_ssl.subjectと2ch_ssl.postをするにしていると2chproxy.plがほぼ土管になって2chproxy.plの使いたい機能が使えません。

### 2chproxy.plを使わない場合

rep2を以下の設定で使う想定です。

```
proxy_use: しない
2ch_ssl.subject: する
2ch_ssl.post: する
```

2chproxy.plは動いていても使わずに直接5chに接続するようになります。

## 構成

### rep2

PHP8に対応した[mikoim/p2-php](https://github.com/mikoim/p2-php)をフォークした[fukumen/p2-php](https://github.com/fukumen/p2-php)を使用しています。
変更したい場合はdocker-compose.ymlを編集してください。

### 2chproxy.pl

5chはいつでもhttps接続に対応した[ma8ma/2chproxy.pl](https://github.com/ma8ma/2chproxy.pl)をフォークした[fukumen/2chproxy.pl](https://github.com/fukumen/2chproxy.pl)を使用しています。
変更したい場合はdocker-compose.ymlを編集してください。

また、2chproxy.plの設定をdocker-compose.ymlに記載できます。
environmentに設定名にNCPX_を頭に付けて記載してください。

### PHP

memory_limitを変更したいなどの理由でphp.iniの設定したい場合、php-local.iniのようなファイルを用意してdocker-compose.ymlでバインドマウントするよう記載してください。

memory_limitはデフォルトで128Mになっています。docker compose logsを確認してAllowed memory size of〜のようなエラーが出る場合には設定してください。

### caddy

rep2への接続はhttp接続とhttps接続が選べます。

デフォルトではhttp接続になっているため、
https接続を使いたい場合はdocker-compose.ymlを編集してLet's Encryptの証明書を設定してください。

### ソフトバージョン

```
ALPINE 3.23
PHP 8.5
CADDY 2.11
COMPOSER 2.9.4
```

新しそうなのを集めたので気分はいいけどかなり怪しい世界。

## docker-compose.override.ymlについて

docker-compose.ymlを編集してしまってもよいですが、docker-compose.override.ymlを別途用意してそちらに記載した方がgit pullをしたときにコンフリクトも起きないのでオススメです。

## デバッグ方法

通常のビルドではgithubのrep2と2chproxy.plを直接参照してビルドしますが、デバッグ用のビルドではdocker-compose.debug.ymlで指定したパスにrep2と2chproxy.plのソースコードをgit cloneしておき、そのソースコードをコンテナに格納します。

また、以下のようなvscodeのワークスペースファイルを用意してください。

```json
{
	"folders": [
		{
			"path": "p2-php"
		},
		{
			"path": "2chproxy.pl"
		},
		{
			"path": "docker-rep2"
		}
	],
	"settings": {
		"files.autoGuessEncoding": true
	},
	"launch": {
		"version": "0.2.0",
		"configurations": [
			{
				"name": "Listen for Xdebug",
				"type": "php",
				"request": "launch",
				"port": 9003,
				"pathMappings": {
					"/var/www/vendor/pear-pear.php.net/HTTP_Request2/HTTP/": "${workspaceFolder:HTTP_Request2}/HTTP",
					"/var/www": "${workspaceFolder:p2-php}",
					"/ext": "${workspaceFolder:docker-rep2}/rep2-data"
				}
			}
		]
	}
}
```

まとめると以下のようなディレクトリ構成としてください。

```
projdir/
  rep2.code-workspace
  docker-rep2/
  p2-php/
  2chproxy.pl/
```

ソースコードが用意できたら以下のように実行してください。

```shell
docker compose -f docker-compose.yml -f docker-compose.debug.yml -f docker-compose.override.yml build
docker compose -f docker-compose.yml -f docker-compose.debug.yml -f docker-compose.override.yml up -d
```

これらの用意をしてvscodeでrep2.code-workspaceを開いてください。
PHP Debug拡張機能を使ってrep2のデバッグが出来ます。
Makefileにこれらのコマンドも入れてあるのでそちらを使うと便利です。

## TODO

ホストのLet's Encryptの証明書を参照するようになっているが、更新されたときにcaddyが読み直してくれないと思うのでなんとかしたい。
そもそもCaddyに証明書の管理をやらせるべきだが、後回しになっている。

過去ログ倉庫の確認をしているときに気がついたが、BEのリンクがbe.2ch.netになっているのでbe.5ch.netに置き換えたい。

## おまけ

2026年1月の途中から今まで使っていたrep2でsubject.txtが取れなくなってしまったのでいろいろやるついでにいつのまにかコンテナ化も更新したいってことで作成。

ma8ma/2chproxy.plを使えばsubject.txtの件は解決するとは分かったのですが、書き込みが出来ないことの解決はハマりました。
決定的な原因がどれかわからないままですが、5chのread.cgiからの書き込みとなるべく近くなるようにfukumen/p2-phpは修正しています。

なお、fukumen/2chproxy.plの方はほぼma8ma/2chproxy.plから変わっていません。

5chでスレ読んでテストスレに書くぐらいの確認しかししていません。
スレ立てはホスト規制の表示まではいけたのでたぶん大丈夫？