up:
	docker compose up -d

up-build:
	docker compose up -d --build

down:
	docker compose down

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

clean:
	docker image prune -f
	docker builder prune -a
