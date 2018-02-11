#!/usr/bin/make
#
# Vim main assistant makefile.
# As configuration for vim is not tribial (depends on how much do you like it)
# The assistant makefiles are splitted in components. Every component adds 
# information 
#
# Created on: 08.11.16

include ../utils/pre-var.mk
### Variables ###

# vim
export VIM_TARGET_VERSION := 8.0
export VIM_BIN            := $(shell which vim)
ifneq ($(VIM_BIN),)
  export VIM_VERSION      := $(shell vim --version | sed '/IMproved/!d' | \
                               sed 's/^.*IMproved \([0-9]*\.[0-9]*\) .*$$/\1/')
endif

# Directories
_VIM_USER_DIR   := $(HOME)/.vim
_VIM_BUNDLE_DIR := $(_VIM_USER_DIR)/bundle
_VIM_FTPLUG_DIR := $(HOME)/.vim/ftplugin

# File
_VIMRC_FILE     := $(HOME)/.vimrc
_HELP_FILE      := $(_VIM_FTPLUG_DIR)/help.vim

# Components are the files which will generate the final rc file.
# Note Vundle is always added the last.
COMPONENTS      := ultisnips.mk python.mk ycm.mk
COMPONENTS      += vundle.mk

PLUGINS         := scrooloose/nerdcommenter scrooloose/syntastic \
                   scrooloose/nerdtree tpope/vim-jdaddy ngmy/vim-rubocop \
                   ctrlpvim/ctrlp.vim jistr/vim-nerdtree-tabs

include $(COMPONENTS)
PACKAGES := vim $(PACKAGES)

include ../utils/post-var.mk

# vimrc body generation
export BODY = $(foreach section,$(SECTIONS)\
    ,"--- $(section) ---"$(NL)$(NL)$($(section))$(NL)$(NL))
VAR_LIST += BODY

### Specific rules ###
$(_VIMRC_FILE): $(COMPONENTS) 

vim.install:
	@if [ ! "$(VIM_VERSION)" = "$(VIM_TARGET_VERSION)" ]; then \
      sh vim$(VIM_TARGET_VERSION)_ubuntu_build.sh; \
    fi
	@$(ECHO) $(call msg_ok,'$(basename $@)' is installed); \
