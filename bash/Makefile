#!/usr/bin/make
#
# Assistence makefile for bash
#
# Created on: 04.11.16

include ../utils/pre-var.mk

### Variables ###
# Files
_ALIAS_FILE                   := $(HOME)/.bash_aliases
_BASHRC_FILE                  := $(HOME)/.bashrc

export PROMPT_SCRIPT_FILE     := $(abspath prompt.sh)
export GIT_SCRIPT_FILE        := $(abspath git.sh)
export FILESEARCH_SCRIPT_FILE := $(abspath file_search.sh)

# Substitution variables list
VAR_LIST = GIT_SCRIPT_FILE FILESEARCH_SCRIPT_FILE PROMPT_SCRIPT_FILE

include ../utils/post-var.mk
