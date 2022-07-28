.EXPORT_ALL_VARIABLES:
.SILENT:
.PHONY: $(MAKECMDGOALS)
.DEFAULT_GOAL: usage

ANSIBLE_PLAYBOOK_NAME ?= main.yaml
ANSIBLE_PLAYBOOK_INVENTORY ?= inventory.yaml
ANSIBLE_PLAYBOOK_TAGS ?=
ANSIBLE_PLAYBOOK_VARSFILE ?=
ANSIBLE_PLAYBOOK_ARGS ?= --inventory $(ANSIBLE_PLAYBOOK_INVENTORY)

ANSIBLE_GALAXY_ROLES = geerlingguy.nodejs geerlingguy.haproxy
ANSIBLE_GALAXY_ARGS_FORCE ?= false
ANSIBLE_GALAXY_ARGS =

usage:
	echo "Usage:"
	echo "  * setup: Install ansible galaxy roles"
	echo "  * run:   Run the playbook"

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

ifeq ($(ANSIBLE_GALAXY_ARGS_FORCE), true)
ANSIBLE_GALAXY_ARGS += --force
endif

define install_ansible_galaxy_role
	ansible-galaxy install $(1) $(ANSIBLE_GALAXY_ARGS)
endef

install_roles:
# $(foreach role,$(ANSIBLE_GALAXY_ROLES),\
# 	$(call install_ansible_galaxy_role,$(role))\
# )
	$(call install_ansible_galaxy_role,geerlingguy.nodejs)
	$(call install_ansible_galaxy_role,geerlingguy.haproxy)
setup: install_roles

ifneq ($(ANSIBLE_PLAYBOOK_VARSFILE),)
ANSIBLE_PLAYBOOK_ARGS += --extra-vars @$(ANSIBLE_PLAYBOOK_VARSFILE)
endif

run: setup
	ansible-playbook \
		$(ANSIBLE_PLAYBOOK_ARGS) \
		$(ANSIBLE_PLAYBOOK_NAME)
