#!/usr/bin/make
#
# File containing some utilities shared between makefiles.
#
# Author: Eduardo Lezcano (eduardo.lezcano@be.atlascopco.com)

#######################################################################
#                              Variables                              #
#######################################################################

# Utils dir path
UTILS_MK_PATH  := $(abspath $(lastword $(MAKEFILE_LIST)))
UTILS_DIR      := $(patsubst %/,%,$(dir $(UTILS_MK_PATH)))

#OS identification
HOST_OS        ?= $(shell uname -s | sed 's/MINGW32_//;s/CYGWIN_//')

# Macros
ECHO           := echo
TAB_STDOUT     := | sed 's/^/\t/'
MUTE_STDOUT    := 1> /dev/null
MUTE_ALLOUT    := &> /dev/null

# Functions
stdout.tab      = $(1) $(TAB_STDOUT) 
stdout.mute     = $(1) $(MUTE_STDOUT)
date           := `date +"%H:%M:%S"`

# Color definitions
ifneq "$(HOST_OS)" "NT-6.1"
  ifneq "$(shell which tput)" ""
    ifeq "8" "$(shell tput colors 2>/dev/null)"
      bb = $(shell tput bold)
      ul = $(shell tput smul)
      hl = $(shell tput smso)
      no = $(shell tput sgr0)
      dm = $(shell tput dim)
      bk = $(shell tput setaf 0)
      rd = $(shell tput setaf 1)
      gr = $(shell tput setaf 2)
      ye = $(shell tput setaf 3)
      bl = $(shell tput setaf 4)
      ma = $(shell tput setaf 5)
      cy = $(shell tput setaf 6)
      wh = $(shell tput setaf 7)
    endif
  endif
endif

# Message formatting
msg.g           = "[$(gr)$(1)$(no)] $(date) : $(2)"
msg.r           = "[$(rd)$(1)$(no)] $(date) : $(2)"
msg.y           = "[$(ye)$(1)$(no)] $(date) : $(2)"
msg.b           = "[$(bl)$(1)$(no)] $(date) : $(2)"
msg.ok          = $(call msg.g,  OK  ,$(1))
msg.err         = $(call msg.r,ERROR ,$(1))
msg.warn        = $(call msg.y, WARN ,$(1))

#######################################################################
#                           Canned recipes                            #
#######################################################################

# $(call file.remove_comments, [fileA], [fileB])
# Filters fileA to fileB removing all comments and empty lines (for # commented
# files only).
_REMOVE_COMMENT_LINES=/^[[:blank:]]*\#/d
_REMOVE_EMPTY_LINES=/^[[:blank:]]*$$/d
_REMOVE_COMMENTS=s/\#.*//

define file.remove_comments
   sed '$(_REMOVE_COMMENT_LINES);$(_REMOVE_EMPTY_LINES);$(_REMOVE_COMMENTS)' $(1) > $(2) 
endef

#######################################################################
#                               Targets                               #
#######################################################################

sudo.check :
	@if [ `id -u` != "0" ]; then \
	  $(ECHO) $(call msg.err,Run 'sudo make ...');\
	  exit 1; \
	fi

.PHONY: %.check
%.check:
	@if [ -z `which $(basename $@)` ]; then \
	  $(ECHO) $(call msg.err,'$(basename $@)' is not installed); \
	  exit 1; \
	fi

UTILS_MK := loaded
