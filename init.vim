filetype plugin on
set modeline
set modelines=5
syntax on
" filetype plugin indent on
" line wrap
set wrap linebreak

set nocompatible

" set exrc
" set secure

set mouse=a
set number
set relativenumber
set clipboard=unnamed
" wayland clipboard
" clipboard sync

if !empty($WAYLAND_DISPLAY)
  let g:clipboard = {
  \   'name': 'wlClipboard',
  \   'copy': {
  \       '+': 'wl-copy',
  \       '*': 'wl-copy -p',
  \   },
  \   'paste': {
  \       '+': 'wl-paste -n',
  \       '*': 'wl-paste -p -n',
  \   },
  \   'cache_enabled': 1,
  \}
endif


set wildmenu

set cursorline

set expandtab
set shiftwidth=2
set softtabstop=2
set printexpr=

" overlength
" highlight OverLength ctermbg=darkgrey guibg=#111111
" match OverLength /\%81v.\+/
set colorcolumn=81,121

" live search and replace
set inccommand=nosplit

" select just pasted text
" https://vim.fandom.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" vim-plug
call plug#begin('~/.local/share/nvim/plugged')
"Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-repeat'
"Plug 'easymotion/vim-easymotion'
Plug 'itchyny/lightline.vim'
Plug 'farmergreg/vim-lastplace'
Plug 'tpope/vim-surround'
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
"Plug 'luochen1990/rainbow'
Plug 'airblade/vim-gitgutter'
"Plug 'tpope/vim-fugitive'
"Plug 'scrooloose/nerdtree'
Plug 'lervag/vimtex'
"Plug 'majutsushi/tagbar'
Plug 'machakann/vim-highlightedyank'
Plug 'tommcdo/vim-exchange'
Plug 'nelstrom/vim-visual-star-search'
Plug 'thaerkh/vim-workspace'
"Plug 'vhdirk/vim-cmake'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'godlygeek/tabular'
Plug 'fanosta/hotcrp_vim'
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
"Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'derekwyatt/vim-fswitch'
call plug#end()

"lightline
let g:lightline={'colorscheme': 'solarized'}
"let g:lightline = {
"      \ 'colorscheme': 'solarized',
"      \ 'active': {
"      \   'right': [ [ 'lineinfo' ], [ 'percent', 'wordcount' ], [ 'fileformat', 'fileencoding', 'filetype' ] ]
"      \ },
"      \ 'component_function': {
"      \   'wordcount': 'WordCount',
"      \ },
"      \ }


set laststatus=2
set noshowmode

syntax enable
set background=dark
set termguicolors
let g:neosolarized_contrast = "high"
let g:neosolarized_visibility = "high"
colorscheme NeoSolarized

" YouCompleteMe
set completeopt-=preview
let g:ycm_folder='$HOME/.config/nvim/plugins/YouCompleteMe/'
let g:ycm_server_python_interpreter='/usr/bin/python3'

nmap <silent> gd :YcmCompleter GoToDefinition<CR>
nmap <silent> gD :YcmCompleter GoToDeclaration<CR>
nmap <silent> gr :YcmCompleter GoToReferences<CR>

function SetCompleteMode(mode)
    if !exists('g:ycm_force_mode') || !g:ycm_force_mode
        let g:ycm_global_ycm_extra_conf=g:ycm_folder . "ycm_" . a:mode . ".py"
        if exists(':YcmRestartServer')
            YcmRestartServer
        endif
    endif
endfunction
command -nargs=* CompleteMode call SetCompleteMode(<f-args>)

nmap <silent> <C-p> :FZF<CR>


au FileType c CompleteMode c
au FileType cpp CompleteMode cpp
au FileType python CompleteMode python

" splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" easy motion
map <Leader> <Plug>(easymotion-prefix)

" rainbow parenthesis
let g:rainbow_active = 1

" UltiSnips
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" LaTeX spell check
autocmd Syntax tex set spell
autocmd Syntax markdown set spell
autocmd Syntax gitcommit set spell
autocmd Syntax rst set spell
autocmd Syntax text set spell

autocmd Syntax go IndentMode t 4

" smart case
set ignorecase
set smartcase

" vimtex
let g:tex_flavor = 'latex'

" let g:latex_view_general_viewer = 'zathura'
" let g:vimtex_view_method = "zathura"

let g:vimtex_compiler_progname = 'nvr' " neovim support
"let g:vimtex_compiler_latexmk = {'callback' : 0}
"let g:vimtex_fold_enabled = 1
"let g:vimtex_fold_manual = 1

" let g:vimtex_compiler_method = 'latexrun'
" let g:vimtex_compiler_latexrun = {
"     \ 'backend' : 'nvim',
"     \ 'background' : 1,
"     \ 'build_dir' : '',
"     \ 'options' : [
"     \   '-verbose-cmds',
"     \   '--latex-args="-synctex=1 -shell-escape"',
"     \   '--bibtex-cmd=biber',
"     \   '--latex-cmd="lualatex"',
"     \ ],
"     \}



" 
" " completion for ycm
"if !exists('g:ycm_semantic_triggers')
  "let g:ycm_semantic_triggers = {}
"endif
"let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme

" search highlight
" Press Space to turn off highlighting and clear any message already displayed.
:nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

"nnoremap / /\v
"vnoremap / /\v
"cnoremap %s/ %smagic/
"cnoremap \>s/ \>smagic/
"nnoremap :g/ :g/\v
"nnoremap :g// :g//

:nnoremap <silent> <Backspace> 1z=

" gitgutter
command GG GitGutter
" faster gutter updates (every 100ms)
set updatetime=100

" nerd tree
map <C-n> :NERDTreeToggle<CR>
" tagbar
let g:tagbar_autofocus = 1
let g:tagbar_left = 1
nmap <C-b> :TagbarToggle<CR>


" nerd comment
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'

" cycle through tabs using H/L
nnoremap H gT
nnoremap L gt
" use Alt+<number> for switching tabs
nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-5> 5gt
nnoremap <A-6> 6gt
nnoremap <A-7> 7gt
nnoremap <A-8> 8gt
nnoremap <A-9> 9gt
nnoremap <silent> <A-0> :tablast<CR>

map Y y$

" easier terminal escape
tnoremap <Esc> <C-\><C-n>

" vim workspace
let g:workspace_session_disable_on_args = 1

"FZF foo
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

autocmd Syntax cpp nmap <silent> <Leader>q :FSHere<cr>
autocmd Syntax cpp nmap <silent> <Leader>Q :FSTab<cr>
