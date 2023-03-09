" Vim needs a POSIX-Compliant shell. Fish is not.
if $SHELL =~ 'bin/fish'
	set shell=/bin/sh
endif

so $HOME/.config/nvim/dein.vim

if exists('g:vscode')
	so $HOME/.config/nvim/vscode.vim
endif

noremap h <nop>
noremap j <nop>
noremap k <nop>
noremap l <nop>

