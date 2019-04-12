DB_NAME ?= provoice
MYSQL := MYSQL_PWD=$(DB_PASS) mysql -u $(DB_USER)

all: help

help: ## Show usage
	@grep -E '^[ a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

create: ## Create new database
	@echo 'CREATE DATABASE IF NOT EXISTS' $(DB_NAME) | $(MYSQL)

drop: ## Drop database
	@echo 'DROP DATABASE IF EXISTS' $(DB_NAME) | $(MYSQL)

migrate: ## Apply database migrations
	@python3 app.py migrate

fresh: drop create migrate ## Rebuild database
	@echo 'Done.'

serve: ## Run server
	@python3 app.py runserver
