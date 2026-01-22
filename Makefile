up:
	docker compose up -d --build

debug:
	docker compose -f docker-compose.yml -f docker-compose.debug.yml up -d

down:
	docker compose down

build:
	docker compose -f docker-compose.yml -f docker-compose.debug.yml build #--progress=plain
	docker image prune -f

logs:
	docker compose logs -f

exec:
	docker compose exec rep2php8 /bin/sh

clean:
	docker image prune -f
	docker builder prune -a