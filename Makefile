.PHONY: help up down restart logs logs-app logs-db logs-redis pull ps status clean backup shell-app fix-permissions

# Default target
.DEFAULT_GOAL := help

help: ## Show this help message
	@echo "Nextcloud Docker - Available Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

up: ## Start all containers
	docker-compose up -d

down: ## Stop all containers
	docker-compose down

restart: ## Restart all containers
	docker-compose restart

logs: ## View logs from all services (follow mode)
	docker-compose logs -f

logs-app: ## View logs from Nextcloud app only
	docker-compose logs -f app

logs-db: ## View logs from MariaDB only
	docker-compose logs -f db

logs-redis: ## View logs from Redis only
	docker-compose logs -f redis

pull: ## Pull latest Docker images
	docker-compose pull

update: pull up ## Update images and restart containers
	@echo "Update completed!"

ps: ## Show status of containers
	docker-compose ps

status: ps ## Alias for ps

backup: ## Backup Nextcloud and database data
	@echo "Creating backups..."
	docker run --rm -v nextcloud_nextcloud_data:/data -v $(PWD):/backup ubuntu tar czf /backup/nextcloud-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz /data
	docker run --rm -v nextcloud_db_data:/data -v $(PWD):/backup ubuntu tar czf /backup/db-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz /data
	@echo "Backups created successfully!"

clean: ## Stop and remove all containers and volumes (DESTRUCTIVE!)
	@echo "WARNING: This will delete all data!"
	@read -p "Are you sure? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker-compose down -v; \
		echo "All containers and volumes removed."; \
	else \
		echo "Operation cancelled."; \
	fi

shell-app: ## Open shell in Nextcloud container
	docker-compose exec app bash

fix-permissions: ## Fix Nextcloud permissions
	docker-compose exec app chown -R www-data:www-data /var/www/html
	@echo "Permissions fixed!"
