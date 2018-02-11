#!/usr/bin/make
#
# Snippets plugin to be very happy and improve your productivity.
#
# Created on: 08.11.16

PLUGINS    += SirVer/ultisnips honza/vim-snippets
SECTIONS   += ULTISNIPS_SECTION
SNIPS_PARENT_DIR=$(shell pwd)

define ULTISNIPS_SECTION
" Ultisnips needs rtp directed to the paret of the snippets folder.
set rtp+=$(SNIPS_PARENT_DIR)
" Snippets directory
let g:UltiSnipsSnippetsDir="$(SNIPS_PARENT_DIR)/UltiSnips"

" Snippets variables
let g:snips_author=Strip(system('git config --global --get user.name'))
let g:snips_email=Strip(system('git config --global --get user.email'))
let g:snips_github=Strip(system('git config --global --get user.github'))
let g:snips_company=Strip(system('git config --global --get user.company'))

let g:UltiSnipsExpandTrigger="<c-space>"
let g:UltiSnipsListSnippets="<c-b>"

" :UltiSnipsEdit command splits current window
let g:UltiSnipsEditSplit="vertical"
endef
