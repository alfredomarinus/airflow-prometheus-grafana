.PHONY: up down restart logs reset status shell

up:
	docker-compose --profile monitoring --profile dashboard up -d

down:
	docker-compose --profile monitoring --profile dashboard down

restart:
	docker-compose --profile monitoring --profile dashboard restart

logs:
	docker-compose logs -f

reset:
	docker-compose --profile monitoring --profile dashboard down -v
	docker-compose --profile monitoring --profile dashboard up -d

status:
	docker-compose ps

shell:
	docker-compose exec airflow-api-server bash
