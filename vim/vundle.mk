#!/usr/bin/make
#
# Vundle component for vim assistant makefiles
#
# Created on: 08.11.16

# To avoid 'cheating' vundle uses the same mechanism than for other plugins.
# But you want Vundle to be loaded first. Believe me.
PLUGINS       := gmarik/Vundle.vim ${PLUGINS}
SECTIONS      := VUNDLE_SECTION ${SECTIONS}
PACKAGES      := vundle $(PACKAGES)
VUNDLE_DIR   := $(_VIM_BUNDLE_DIR)/Vundle.vim

define VUNDLE_SECTION
" Vundle is a plugin manager for vim.
" This is it's initialization section.

set rtp+=$(VUNDLE_DIR)
call vundle#begin()

$(foreach plugin,$(PLUGINS),Plugin '$(plugin)'$(NL))

call vundle#end()
endef

vundle.install: | $(_VIM_BUNDLE_DIR)
	@if [ ! -d "$(VUNDLE_DIR)" ]; then \
	  git clone https://github.com/VundleVim/Vundle.vim.git \
		$(VUNDLE_DIR); \
	else \
	  cd $(VUNDLE_DIR); \
	  git pull; \
	fi
	@vim +PluginInstall +qall;
	@$(ECHO) $(call msg_ok,Installed vundle for vim)

vundle.uninstall:
	rm -fr $(VUNDLE_DIR) 

vundle.check: ;
