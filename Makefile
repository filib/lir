.DEFAULT_GOAL := help

help: ## Print available tasks
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## Install dependencies
	@bower install

watch: ## Recompile on file system changes
	@pulp --watch build

pack: ## Pack single JavaScript file for use in the browser
	@rm bundle/lir.js
	@pulp build --optimise -- --strict --censor-lib --stash
	@psc-bundle output/**/*.js $(shell cat "exposed_modules" | xargs -I % echo -n "-m % ") -o bundle/lir.js -n Lir

.PHONY:
	install
	watch
	pack
	help
