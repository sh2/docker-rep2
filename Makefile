up:
	podman compose up -d

up-build:
	podman compose up -d --build

down:
	podman compose down

pull:
	podman compose pull

debug:
	podman compose -f docker-compose.yml -f docker-compose.debug.yml -f docker-compose.override.yml up -d

build:
	podman compose -f docker-compose.yml -f docker-compose.debug.yml -f docker-compose.override.yml build #--progress=plain
	podman image prune -f

build-local:
	podman compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.override.yml build
	podman image prune -f

config:
	podman compose -f docker-compose.yml -f docker-compose.debug.yml -f docker-compose.override.yml config
	podman image prune -f

config-local:
	podman compose -f docker-compose.yml -f docker-compose.local.yml -f docker-compose.override.yml config
	podman image prune -f

logs:
	podman compose logs -f

exec:
	podman compose exec rep2php8 /bin/sh

update:
	podman compose cp ../p2-php/lib rep2php8:/var/www
	podman compose cp ../p2-php/rep2 rep2php8:/var/www
	podman compose exec rep2php8 chown -R root:root /var/www/lib
	podman compose exec rep2php8 chown -R root:root /var/www/rep2

confdiff:
	podman compose exec rep2php8 diff /var/www/conf.orig /ext/conf | iconv -f SHIFT_JIS -t UTF-8

clean:
	podman image prune -f
	podman builder prune -a

-include local.mk
