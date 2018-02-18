#!/bin/bash

PLUGINS=junegunn/fzf
SECTIONS=FUZZYFINDER_SECTION 
PACKAGES=fzf 
_FZF_DIR=~/.fzf
if [ ! -d $_FZF_DIR]; then
	git clone --depth 1 https://github.com/junegunn/fzf.git $_FZF_DIR
else
	cd $LOCALREPO
	git pull $REPOSRC
fi
$(_FZF_DIR)/install

