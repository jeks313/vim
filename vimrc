set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" Package Manager
" let Vundle manage Vundle required!
Bundle 'gmarik/vundle'

" Bundles Here:
"
" Golang Development: vim-go
" Useful Shortcuts:
" GoDeclsDir: ,gt - lists all functions and types in your project, fuzzy complete, so just start typing
" GoLint: cn, cp - go to next error, previous error 
" Movement: [[, ]] move to next function
" Defs: gd, c-t - go to definition, return
Bundle 'fatih/vim-go'

" Ultisnips
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'

" Themes
Bundle 'fatih/molokai'
Bundle 'morhetz/gruvbox'
Bundle 'https://github.com/altercation/vim-colors-solarized.git'
Bundle 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Ctrlp
" Fuzzy text completion, used in GoDeclsDir to fuzzy complete function names
" Bundle 'ctrlp.vim'

" SuperTab
" Does autocompletion with the tab key in a smart way
Bundle 'ervandew/supertab'

" vim-easymotion
" ,,fb (find char)
" ,,Fb (find char, backwards)
" ,,w  (words)
" s{char}{char} (search for charchar, works across windows)
Bundle 'Lokaltog/vim-easymotion'
Plugin 'haya14busa/incsearch.vim'
Plugin 'haya14busa/incsearch-easymotion.vim'

" Opens a side bar, uses ctags to list all the imports, functions and types
Bundle 'majutsushi/tagbar'

" vim-scripts repos
" Bundle 'L9'

" delimitMate - autocloses quotes and brackets
Bundle 'Raimondi/delimitMate'

" autocomplete functions in go code
Bundle 'Shougo/neocomplete.vim'

" vim-commentary
" gcc - comment out a line
" gcap - commend out a paragraph
Plugin 'tpope/vim-commentary'

" vim-surround
" cs"' - changes "s to 's when inside something quoted
" ys<nav><quote> surrounds nav with quote, e.g. ysw" yst)"
Plugin 'tpope/vim-surround'

" quick file finder
" ,t - opens finder buffer, fuzzy finds filenames
Plugin 'wincent/command-t'

" auto linter, lints as you type and on save
Plugin 'w0rp/ale'

" adds tests for functions
" :GoTests when on a function
Plugin 'buoto/gotests-vim'

" git gutter
Plugin 'airblade/vim-gitgutter'

"--------------------------------------------------------------------------------
" vim-easymotion
" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" incsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
map / <Plug>(incsearch-easymotion-/)
map ? <Plug>(incsearch-easymotion-?)
"--------------------------------------------------------------------------------

let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

call ale#linter#Define('go', {
\   'name': 'revive',
\   'output_stream': 'both',
\   'executable': 'revive',
\   'read_buffer': 0,
\   'command': 'revive %t',
\   'callback': 'ale#handlers#unix#HandleAsWarning',
\})

let g:ale_go_gometalinter_options = '--fast'
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'

" autocmd VimEnter * nested TagbarOpen
nmap <F8> :TagbarToggle<CR>

filetype plugin indent on     " required!

let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"

let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

let g:neocomplete#enable_at_startup = 1

syntax on

let g:molokai_original = 1
try
    colorscheme gruvbox
catch /^Vim\%((\a\+)\)\=:E185/
    " added so that docker can install the plugins without bailing
endtry

set background=dark
set shiftwidth=4
set expandtab
set tabstop=4

au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <leader>l <Plug>(go-decls)
au Filetype go nmap <leader>ga <Plug>(go-alternate-edit)
au Filetype go nmap <leader>gav <Plug>(go-alternate-vertical)
au FileType go nmap <leader>gt :GoDeclsDir<cr>

set re=1

" vim-go
let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1

" Open :GoDeclsDir with ctrl-g
nmap <C-g> :GoDeclsDir<cr>
imap <C-g> <esc>:<C-u>GoDeclsDir<cr>

let mapleader=","

let g:delimitMate_expand_cr = 2

autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

""""""""""""""""""""""
"      Settings      "
"                    "
""""""""""""""""""""""
set nocompatible                " Enables us Vim specific features
set t_ut=                       " Stops redraw from messing up background
set t_Co=256
set undofile                    " maintain undo history between files"
set undodir=$HOME/.vim/undo     " where to save undo histories
filetype off                    " Reset filetype detection first ...
filetype plugin indent on       " ... and enable filetype detection
" set ttyfast                     " Indicate fast terminal conn for faster redraw
"set ttymouse=xterm2             " Indicate terminal type for mouse codes
set ttyscroll=3                 " Speedup scrolling
set laststatus=2                " Show status line always
set encoding=utf-8              " Set default encoding to UTF-8
set autoread                    " Automatically read changed files
set autoindent                  " Enabile Autoindent
set backspace=indent,eol,start  " Makes backspace key more powerful.
set incsearch                   " Shows the match while typing
set hlsearch                    " Highlight found searches
set noerrorbells                " No beeps
set number                      " Show line numbers
set showcmd                     " Show me what I'm typing
set noswapfile                  " Don't use swapfile
set nobackup                    " Don't create annoying backup files
set splitright                  " Vertical windows should be split to right
set splitbelow                  " Horizontal windows should split to bottom
set autowrite                   " Automatically save before :next, :make etc.
set hidden                      " Buffer should still exist if window is closed
set fileformats=unix,dos,mac    " Prefer Unix over Windows over OS 9 formats
set noshowmatch                 " Do not show matching brackets by flickering
set noshowmode                  " We show the mode with airline or lightline
set ignorecase                  " Search case insensitive...
set smartcase                   " ... but not it begins with upper case
set completeopt=menu,menuone    " Show popup menu, even if there is one entry
set pumheight=30                " Completion window max size
set nocursorcolumn              " Do not highlight column (speeds up highlighting)
set nocursorline                " Do not highlight cursor (speeds up highlighting)
set lazyredraw                  " Wait to redraw
set updatetime=200
set relativenumber

let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:tagbar_type_go = {
        \ 'ctagstype' : 'go',
        \ 'kinds'     : [
            \ 'p:package',
            \ 'i:imports:1',
            \ 'c:constants',
            \ 'v:variables',
            \ 't:types',
            \ 'n:interfaces',
            \ 'w:fields',
            \ 'e:embedded',
            \ 'm:methods',
            \ 'r:constructor',
            \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

autocmd FileType * nested :call tagbar#autoopen(0)
