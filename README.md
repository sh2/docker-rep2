# docker-rep2

## 概要

以下のソフトをdockerコンテナを作成するDockerfileとdocker-compose.ymlです。
[pen/docker-rep2](https://github.com/pen/docker-rep2)のフォークです。

* rep2
* 2chproxy.pl
* caddy + PHP 他

## 使い方

git, docker, docker composeなどが必要です。

そのまま設定で使うなら以下を実行すればコンテナをビルドして起動までしてくれます。
標準ではポート番号は10088です。

```shell
git clone https://github.com/fukumen/docker-rep2.git
cd docker-rep2
docker compose up -d --build
```

### 2chproxy.plを使う場合(デフォルト)

rep2を以下の設定で使う想定です。

proxy_use: する
proxy_host: 127.0.0.1
proxy_port: 8080
2ch_ssl.subject: しない
2ch_ssl.post: しない

2ch_ssl.subjectと2ch_ssl.postをするにしていると2chproxy.plがほぼ土管になって2chproxy.plの使いたい機能が使えません。

### 2chproxy.plを使わない場合

rep2を以下の設定で使う想定です。

proxy_use: しない
2ch_ssl.subject: する
2ch_ssl.post: する

2chproxy.plは動いていても使わずに直接5chに接続するようになります。

## 構成

### rep2

PHP8に対応した[mikoim/p2-php](https://github.com/mikoim/p2-php)をフォークした[fukumen/p2-php](https://github.com/fukumen/p2-php)を使用しています。
変更したい場合はdocker-compose.ymlを編集してください。

## 2chproxy.pl

5chはいつでもhttps接続に対応した[ma8ma/2chproxy.pl](https://github.com/ma8ma/2chproxy.pl)をフォークした[fukumen/2chproxy.pl](https://github.com/fukumen/2chproxy.pl)を使用しています。
変更したい場合はdocker-compose.ymlを編集してください。

## caddy

rep2への接続はhttp接続とhttps接続が選べます。

デフォルトではhttp接続になっているため、
https接続を使いたい場合はdocker-compose.ymlを編集してLet's Encryptの証明書を設定してください。

## ソフトバージョン

ALPINE 3.23
PHP 8.5
CADDY 2.11
COMPOSER 2.9.4

新しそうなのを集めたので気分はいいけどかなり怪しい世界。

## デバッグ方法

デバッグ用のビルドではdocker-compose.debug.ymlで指定したパスにrep2と2chproxy.plのソースコードをgit cloneしておき、そのソースコードをコンテナに格納します。
デフォルトではこのディレクトリの親のp2-phpと2chproxy.plになっています。

ソースコードが用意できたら以下のように実行してください。

```shell
docker compose -f docker-compose.yml -f docker-compose.debug.yml
docker compose -f docker-compose.yml -f docker-compose.debug.yml up -d
```

vscodeでPHP Debug拡張機能を使ってrep2のデバッグが出来ます。
Makefileにこれらのコマンドも入れてあるのでそちらを使うと便利です。

## TODO

ホストのLet's Encryptの証明書を参照するようになっているが、更新されたときにcaddyが読み直してくれないと思うのでなんとかしたい。
そもそもCaddyに証明書の管理をやらせるべきだが、後回しになっている。

## おまけ

2026年1月の途中から今まで使っていたrep2でsubject.txtが取れなくなってしまったのでいろいろやるついでにいつのまにかコンテナ化も更新したいってことで作成。

ma8ma/2chproxy.plを使えばsubject.txtの件は解決するとは分かったのですが、書き込みが出来ないことの解決はハマりました。
決定的な原因がどれかわからないままですが、5chのread.cgiからの書き込みとなるべく近くなるようにfukumen/p2-phpは修正しています。

なお、fukumen/2chproxy.plの方はほぼma8ma/2chproxy.plから変わっていません。

5chでスレ読んでテストスレに書くぐらいの確認しかししていません。
スレ立てはホスト規制の表示まではいけたのでたぶん大丈夫？
