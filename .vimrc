" Vim needs a POSIX-Compliant shell. Fish is not.
if $SHELL =~ 'bin/fish'
	set shell=/bin/sh
endif

" Load Vundle as plugin manager
:so ~/.vim/Vundle.vim

" Bundles
"" EditorConfig
Bundle 'editorconfig/editorconfig-vim'
"" Tomorrow colors
Bundle 'david50407/tomorrow-theme-vim'
color Tomorrow-Night-Bright

"" Powerline / Airline
Bundle 'Lokaltog/vim-powerline'
set laststatus=2
let g:Powerline_symbols = 'fancy'
" Airline sucks now :(
" Bundle 'bling/vim-airline'
" let g:airline_powerline_fonts=0
" let g:airline_left_sep="\u2b80"
" let g:airline_right_sep="\u2b82"

" Scrollbar
" Plugin 'lornix/vim-scrollbar'

"" Minimap
" Plugin 'severin-lemaignan/vim-minimap'
" Plugin 'mipmip/vim-minimap'

"" Vim for Ruby
Bundle 'vim-ruby/vim-ruby'
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd BufRead,BufNewFile Podfile set filetype=ruby

"" Vim for CoffeeScript
" Bundle 'kchmck/vim-coffee-script'
" au BufRead,BufNewFile *.coffee set filetype=coffee

"" SnipMate
" Bundle 'tomtom/tlib_vim'
" Bundle 'marcweber/vim-addon-mw-utils'
" Bundle 'garbas/vim-snipmate'

"" Emmet / ZenCoding
Bundle 'mattn/emmet-vim'
let g:user_emmet_mode='inv'  "enable when Insert, Normal, Visual
" Enable just for html/css:
" let g:user_emmet_install_global = 0
" autocmd FileType html,css EmmetInstall
let g:user_emmet_settings = { 'indentation' : '  ' } " two spaces
let g:use_emmet_complete_tag = 1

"" The NERD Tree
Bundle 'scrooloose/nerdtree'

"" GitGutter
Bundle 'airblade/vim-gitgutter'

"" SuperTab
Bundle 'ervandew/supertab'

"" XTerm Color Table # Useful in terminal
Bundle 'guns/xterm-color-table.vim'

"" Cute Error Marker
" Bundle 'Twinside/vim-cuteErrorMarker'

"" Yaml
Bundle 'avakhov/vim-yaml'

"" Slim
" Bundle 'slim-template/vim-slim'
" au  BufRead,BufNewFile *.slim   set filetype=slim

"" SCSS
Bundle 'cakebaker/scss-syntax.vim'

"" HTML5
Bundle 'othree/html5.vim'

"" JSX React.js
Bundle 'pangloss/vim-javascript'
Bundle 'mxw/vim-jsx'
let g:javascript_enable_domhtmlcss = 1
let g:jsx_ext_required = 0

"" Crystal
Bundle 'rhysd/vim-crystal'
au  BufRead,BufNewFile *.{cr,ecr}   set filetype=crystal

" Configs
syntax on
set modeline
set t_Co=256
set tabstop=2
set softtabstop=2
set shiftwidth=2
set nocompatible
filetype plugin indent on
set fileencodings=utf8,big5,gbk,latin1

"" improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

"" Markdown
au  BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=markdown
let g:markdown_fenced_languages = ['ruby', 'java', 'html']

"" Auto paste
if &term =~ "xterm.*"
	let &t_ti = &t_ti . "\e[?2004h"
	let &t_te = "\e[?2004l" . &t_te
	function XTermPasteBegin(ret)
		set pastetoggle=<Esc>[201~
		set paste
		return a:ret
	endfunction
	map <expr> <Esc>[200~ XTermPasteBegin("i")
	imap <expr> <Esc>[200~ XTermPasteBegin("")
	cmap <Esc>[200~ <nop>
	cmap <Esc>[201~ <nop>
endif
