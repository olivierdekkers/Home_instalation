#!/usr/bin/make
#
# Include this file BEFORE you start assigning variables.
# It gives some utilities.
#
# Created on: 08.11.16

# Second expansion required for some implicit rules. See further.
.SECONDEXPANSION:

# Some usefull paths independent from the caller.
export UTILS_DIR  := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
export ROOT_DIR   := $(realpath $(dir $(UTILS_DIR)))

# Formatting utils
include $(UTILS_DIR)/format.mk

# Global variable initialization (as simple variables)
PACKAGES          :=
FILES             :=
DIRS              :=

# Definition of New Line character for code generation.
define NL


endef

# Got it from the gmake manual itself ;)
pathsearch = $(firstword $(wildcard $(addsuffix /$(1), $(subst :, ,$(PATH)))))

# Automatic installation stuff 
# TODO: more reliable system to detect OS ex.: uname
ifneq ($(call pathsearch,apt-get),)
  sys.mkdir     = mkdir -p $(1)
  sys.envsubst  = envsubst '$(VAR_LIST:%=$${%})' <$(1) >$(2)
  sys.check     = dpkg --status $(1) $(MUTE_STDERR) | grep installed
  sys.check2    = which $(1)
  sys.install   = sudo apt-get install $(if $(UNATTENDED),-y) $(1)
  sys.uninstall = sudo apt-get remove $(if $(UNATTENDED),-y) $(1)
  pip.install   = sudo pip install $(1)
else
  $(error Your system is not compatible with these makefiles.) 
endif

# Canned recipes
define cr.chown
$(if $(USER),sudo chown $(USER) $@)
$(if $(GROUP),sudo chown :$(GROUP) $@)
endef

define cr.mkdir
$(call sys.mkdir,$@)
$(cr.chown)
@$(ECHO) $(call msg_ok,Directory '$@')
endef

define cr.sudo.mkdir
sudo $(call sys.mkdir,$@)
$(cr.chown)
@$(ECHO) $(call msg_ok,Directory '$@')
endef

define cr.envsubst
$(call sys.envsubst,$<,$@)
$(cr.chown)
@$(ECHO) $(call msg_ok,'$<' -> '$@')
endef

define cr.sudo.envsubst
$(call sys.envsubst,$<,.$(subst .in,.out,$<))
sudo cp .$(subst .in,.out,$<) $@
$(cr.chown)
@$(ECHO) $(call msg_ok,'$<' -> '$@')
endef


__PRE_VAR_MK := 1
