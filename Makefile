SHELL := /bin/bash

# VM target name (from config/targets.yaml) and default snapshot name.
VM ?= sandbox-01
NAME ?= clean-base

# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: clean-vm
clean-vm: ## Clean history/tmp/logs/caches in the VM before snapshotting (VM=<name>)
	vagrant ssh $(VM) -c 'bash /vagrant/res/scripts/clean-before-snapshot.sh'

.PHONY: snapshot
snapshot: ## Snapshot the VM, any provider (VM=<name> NAME=<snapshot>)
	vagrant snapshot save --force $(VM) "$(NAME)"

.PHONY: restore
restore: ## Restore the VM to a snapshot, any provider (VM=<name> NAME=<snapshot>)
	vagrant snapshot restore $(VM) "$(NAME)"

.PHONY: clean-snapshot
clean-snapshot: clean-vm snapshot ## Clean the VM then snapshot it (VM=<name> NAME=<snapshot>)