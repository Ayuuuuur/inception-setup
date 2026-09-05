YML = srcs/docker-compose.yml

up: setup
	docker compose -f $(YML) up --build

setup:
	mkdir -p $(HOME)/data/db $(HOME)/data/wordpress

down:
	docker compose -f $(YML) down

clean: down
	docker rmi -f nginx
	docker rmi -f wordpress
	docker rmi -f mariadb
	docker volume rm srcs_mariadb || true
	docker volume rm srcs_wordpress || true
	sudo rm -rf $(HOME)/data/*

re: clean up

build:
	docker compose -f $(YML) build

start:
	docker compose -f $(YML) start

stop:
	docker compose -f $(YML) stop

logs:
	docker compose -f $(YML) logs

ps:
	docker compose -f $(YML) ps