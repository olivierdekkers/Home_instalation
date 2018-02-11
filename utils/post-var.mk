#!/usr/bin/make
#
# Include this file AFTER your variable assignment block.
# Used like that will generate many general rules in an automated way.
# Keep reading to know how.
#
# Created on: 07.11.16

# Check for required inclusions.
ifndef __PRE_VAR_MK
  $(error 'pre-var.mk' is not included in your makefile.)
endif

# Generation of lists used by some standard targets.
FILES         := $(foreach v,$(filter _%_FILE,$(.VARIABLES)),$(value $(v)))
DIRS          += $(foreach d,$(filter _%_DIR,$(.VARIABLES)),$(value $(d)))
DIRS          += $(dir $(FILES))
DIRS          := $(sort $(DIRS)) 

# We divide the files in two groups: Those which are in your home and those
# which doesn't. This is used to properly apply sudo.
_SYSTEM_DIRS    := $(filter-out ~% $(HOME)%, $(DIRS))
_HOME_DIRS  := $(filter-out $(_SYSTEM_DIRS), $(DIRS))
_SYSTEM_FILES   := $(filter-out ~% $(HOME)%, $(FILES))
_HOME_FILES := $(filter-out $(_SYSTEM_FILES), $(FILES))

%.pipinstall: python-pip.install
	@if [ -z "`pip list --format=columns | grep $(basename $@)`" ]; then \
	  $(call pip.install,$(basename $@)); \
	  $(ECHO) $(call msg_ok,Installed '$(basename $@)'); \
	else \
	  $(ECHO) $(call msg_ok,'$(basename $@)' is already installed); \
	fi

%.install:
	@if [ -z "`$(call sys.check,$(basename $@))`" ]; then \
	  $(call sys.install,$(basename $@)); \
	  $(ECHO) $(call msg_ok,Installed '$(basename $@)'); \
	else \
	  $(ECHO) $(call msg_ok,'$(basename $@)' is already installed); \
	fi

%.uninstall:
	@if [ ! -z "`$(call sys.check,$(basename $@))`" ]; then \
	  $(call sys.uninstall,$(basename $@)); \
	  $(ECHO) $(call msg_ok,Uninstalled '$(basename $@)'); \
	else \
	  $(ECHO) $(call msg_ok,'$(basename $@)' is not installed); \
	fi

%.check:
	@if [ -z "`$(call sys.check,$(basename $@))`" -a \
	      -z "`$(call sys.check2,$(basename $@))`" ]; then \
	  $(ECHO) $(call msg_err,'$(basename $@)' is not installed); \
	$(if $(VERBOSE),else) \
	  $(if $(VERBOSE),$(ECHO) $(call msg_ok,'$(basename $@)' found);) \
	fi

# File creation rules
$(_HOME_FILES): $$(notdir $$@).in Makefile | $$(dir $$@)
	$(cr.envsubst)

$(_SYSTEM_FILES): $$(notdir $$@).in Makefile | $$(dir $$@) sudo.check
	$(cr.sudo.envsubst)

# Directory creation rule
$(_HOME_DIRS):
	$(cr.mkdir)

$(_SYSTEM_DIRS): | sudo.check
	$(cr.sudo.mkdir)

# Main targets rules
.PHONY: config clean install uninstall

config: $(addsuffix .check, $(PACKAGES)) $(DIRS) $(FILES)

clean:
	@$(ECHO) "$(rd)This action will remove files: \
	  $(addprefix \n\t,$(FILES))"
	@read -r -p "Are you sure?$(no) " REPLY; \
	if [ "$$REPLY" = "Y" ] || [ "$$REPLY" = "y" ]; then \
	  sudo rm $(FILES); \
	fi

clean.all:
	@$(ECHO) "$(rd)This action will remove next directories: \
	  $(addprefix \n\t,$(DIRS))"
	@read -r -p "Are you sure?$(no) " REPLY; \
	if [ "$$REPLY" = "Y" ] || [ "$$REPLY" = "y" ]; then \
	  sudo rm -fr $(DIRS); \
	fi

install: $(addsuffix .install,$(PACKAGES))

uninstall: $(addsuffix .uninstall,$(PACKAGES))

info:
	@$(ECHO) "ROOT_DIRECTORY: $(ROOT_DIR)"
	@$(ECHO) "UTILITIES DIRECTORIES: $(UTILS_DIR)"
	@$(ECHO) "HOME: $(HOME)"
	@$(ECHO) "HOME DIRECTORIES: \
		$(addprefix \n\t,$(_HOME_DIRS))"
	@$(ECHO) "SYSTEM DIRECTORIES: \
		$(addprefix \n\t,$(_SYSTEM_DIRS))"
	@$(ECHO) "HOME FILES: \
		$(addprefix \n\t,$(_HOME_FILES))"
	@$(ECHO) "SYSTEM FILES: \
		$(addprefix \n\t,$(_SYSTEM_FILES))"
