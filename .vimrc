syntax on
set backspace=indent,eol,start
set modeline
"ruby
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

"set nocompatible
set laststatus=2
set t_Co=256
set tabstop=2
if ! exists('g:Powerline_symbols')
	exec 'let g:Powerline_symbols = "fancy"'
endif

" let g:Powerline_symbols = 'fancy'

color Tomorrow-Night-Bright

let g:user_zen_settings = {
\  'indentation' : '	',
\}

let g:use_zen_complete_tag = 1
