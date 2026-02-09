up:
	docker compose up -d

up-build:
	docker compose up -d --build

down:
	docker compose down

pull:
	docker compose pull

debug:
	docker compose -f docker-compose.yml -f docker-compose.debug.yml -f docker-compose.override.yml up -d

build:
	docker compose -f docker-compose.yml -f docker-compose.debug.yml -f docker-compose.override.yml build #--progress=plain
	docker image prune -f

build-local:
	docker compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.override.yml build
	docker image prune -f

config:
	docker compose -f docker-compose.yml -f docker-compose.debug.yml -f docker-compose.override.yml config
	docker image prune -f

config-local:
	docker compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.override.yml config
	docker image prune -f

logs:
	docker compose logs -f

exec:
	docker compose exec rep2php8 /bin/sh

update:
	docker compose cp ../p2-php/lib rep2php8:/var/www
	docker compose cp ../p2-php/rep2 rep2php8:/var/www
	docker compose exec rep2php8 chown -R root:root /var/www/lib
	docker compose exec rep2php8 chown -R root:root /var/www/rep2

confdiff:
	docker compose exec rep2php8 diff /var/www/conf.orig /ext/conf | iconv -f SHIFT_JIS -t UTF-8

clean:
	docker image prune -f
	docker builder prune -a

-include local.mk
