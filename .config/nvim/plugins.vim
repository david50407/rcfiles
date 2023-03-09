" Add or remove your plugins here like this:
"call dein#add('Shougo/neosnippet.vim')
"call dein#add('Shougo/neosnippet-snippets')

call dein#add('unblevable/quick-scope')
if exists('g:vscode')
	highlight QuickScopePrimary guifg='#8959a8' guibg='#303030' gui=underline ctermfg=155 cterm=underline
	highlight QuickScopeSecondary guifg='#de935f' gui=underline ctermfg=81 cterm=underline

	" use vscode easymotion when in vscode mode
	call dein#add('asvetliakov/vim-easymotion')
endif
