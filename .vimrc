" Load Vundle as plugin manager
:so ~/.vim/Vundle.vim

" Bundles
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

"" Vim for Ruby
Bundle 'vim-ruby/vim-ruby'
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

"" SnipMate
Bundle 'tomtom/tlib_vim'
Bundle 'marcweber/vim-addon-mw-utils'
Bundle 'garbas/vim-snipmate'

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
Bundle 'Twinside/vim-cuteErrorMarker'

" Configs
syntax on
set modeline
set t_Co=256
set tabstop=2

"" improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

"" Markdown
au  BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=markdown
let g:markdown_fenced_languages = ['ruby', 'java', 'html']

