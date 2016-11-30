.DEFAULT_GOAL := help

PSC-BUNDLE=$(shell npm bin)/psc-bundle
PULP=$(shell npm bin)/pulp

doc: ## Generate documentation
	@$(PULP) docs

install: ## Install dependencies
	@bower install

pack: ## Pack single JavaScript file for use in the browser
	@rm bundle/lir.js
	@touch bundle/lir.js
	$(PULP) build --optimise -- --strict --censor-lib --stash
	$(PSC-BUNDLE) output/**/*.js $(shell cat "exposed_modules" | xargs -I % echo -n "-m % ") -o bundle/lir.js -n Lir

spec: ## Run tests
	$(PULP) test

watch: ## Recompile on file system changes
	$(PULP) --watch build

help: ## Print available tasks
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY:
	doc
	install
	pack
	spec
	watch
	help
