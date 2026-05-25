#!make
include .env

IMAGE_VERSION ?= latest
DOCKER_REGISTRY ?= registry.linkbee.id/zero-hunger-project

export IMAGE_VERSION
export DOCKER_REGISTRY

ps:
	@if [ "$(APP_ENV)" = "local" ]; then \
		docker compose -f docker-compose.local.yaml -p ${DOCKER_NAME} ps; \
	else \
		docker compose -f docker-compose.production.yaml -p ${DOCKER_NAME} ps; \
	fi

serve:
	@if [ "$(APP_ENV)" = "local" ]; then \
		docker compose -f docker-compose.local.yaml -p ${DOCKER_NAME} up -d; \
	else \
		docker compose -f docker-compose.production.yaml -p ${DOCKER_NAME} up -d; \
	fi

serve-with-util:
	@if [ "$(APP_ENV)" = "local" ]; then \
		docker compose -f docker-compose.local.yaml -f docker-compose.util.yaml -p ${DOCKER_NAME} up -d; \
	else \
		docker compose -f docker-compose.production.yaml -f docker-compose.util.yaml -p ${DOCKER_NAME} up -d; \
	fi

down:
	@if [ "$(APP_ENV)" = "local" ]; then \
		docker compose -f docker-compose.local.yaml -f docker-compose.util.yaml -p ${DOCKER_NAME} down; \
	else \
		docker compose -f docker-compose.production.yaml -f docker-compose.util.yaml -p ${DOCKER_NAME} down; \
	fi

shell:
	@if [ "$(APP_ENV)" = "local" ]; then \
		docker compose -f docker-compose.local.yaml -p ${DOCKER_NAME} exec -it web sh; \
	else \
		docker compose -f docker-compose.production.yaml -p ${DOCKER_NAME} exec -it fpm sh; \
	fi

docker-build-web:
	docker build --build-arg IMAGE_VERSION=${IMAGE_VERSION} -f ops/${APP_ENV}/Dockerfile -t zero-hunger-project/web:${IMAGE_VERSION} .

docker-push-web:
	docker tag zero-hunger-project/web:${IMAGE_VERSION} ${DOCKER_REGISTRY}/web:${IMAGE_VERSION}
	docker push ${DOCKER_REGISTRY}/web:${IMAGE_VERSION}
