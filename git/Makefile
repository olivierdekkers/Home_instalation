#!/usr/bin/make
#
# Git home assistance makefile

include ../utils/pre-var.mk

### Variables ###
GITCONFIG_FILE := $(HOME)/.gitconfig
GCFG            := git config --global

include ../utils/post-var.mk

define git.config
@if [ ! "`$(GCFG) $(1)`" ]; then \
  read -p "Enter $(2): " _T; \
  $(GCFG) $(1) "$$_T"; \
fi
endef

### Rules ###
config: $(GITCONFIG_FILE)

$(GITCONFIG_FILE): Makefile
	@$(ECHO) $(call msg_g,CONFIG,Configuring 'git')
	$(GCFG) core.excludesfile '$(realpath gitignore)'
	$(GCFG) push.default simple
	$(GCFG) credential.helper cache
	$(GCFG) credential.helper 'cache --timeout=3600'
	$(call git.config,user.name,complete user name)
	$(call git.config,user.email,user email)
	$(call git.config,user.github,github user)
	$(call git.config,user.company,company name)
	$(call git.config,user.baseurl,url of your main git repository)
