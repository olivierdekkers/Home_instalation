#!/usr/bin/make
#
# Ycm component for vim assistant makefiles
#
# Created on: 08.11.16

PLUGINS     += Valloric/YouCompleteMe
SECTIONS    += YCM_SECTION
PACKAGES    += cmake ycm

_YCM_DIR    := $(_VIM_BUNDLE_DIR)/YouCompleteMe

define YCM_SECTION
" YCM
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
endef

ycm.install:
	@if [ -f $(_YCM_DIR)/built ]; then \
	    $(ECHO) $(call msg_ok,'ycm' already built. Uninstall first to rebuild.); \
	else \
	    $(_YCM_DIR)/install.py --clang-completer; \
	    touch $(_YCM_DIR)/built; \
	fi

ycm.check:
	@if [ -f $(_YCM_DIR)/built ]; then \
	    $(ECHO) $(call msg_ok,'ycm' found.); \
	else \
	    $(ECHO) $(call msg_err,'ycm' is not installed.); \
	fi
