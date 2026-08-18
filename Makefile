YML = srcs/docker-compose.yml

up: setup
	docker-compose -f $(YML) up --build

setup:
	mkdir -p $(HOME)/data/db $(HOME)/data/wordpress

build:
	docker-compose -f $(YML) build

down:
	docker-compose -f $(YML) down

start:
	docker-compose -f $(YML) start

stop:
	docker-compose -f $(YML) stop

restart:
	docker-compose -f $(YML) restart

logs:
	docker-compose -f $(YML) logs

ps:
	docker-compose -f $(YML) ps

remove-all:
	docker rmi $$(docker images -aq) ; docker volume prune -f $$(docker volume ls -q) ; docker system prune -f 