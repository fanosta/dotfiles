filetype plugin indent on
set modeline
set modelines=5
" line wrap
set wrap linebreak
set tabstop=4

set nocompatible

" set exrc
" set secure

set mouse=a
set number
set relativenumber
set clipboard=unnamed

set cursorline
set expandtab
set shiftwidth=2
set softtabstop=2
" set printexpr= " prevent accidental printing

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
Plug 'airblade/vim-gitgutter'
Plug 'cespare/vim-toml'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'derekwyatt/vim-fswitch'
Plug 'fanosta/hotcrp.vim'
Plug 'farmergreg/vim-lastplace'
Plug 'gaving/vim-textobj-argument'
Plug 'github/copilot.vim'
Plug 'godlygeek/tabular'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'kaarmu/typst.vim'
Plug 'kyoh86/vim-jsonl'
Plug 'machakann/vim-highlightedyank'
Plug 'mechatroner/rainbow_csv'
Plug 'nelstrom/vim-visual-star-search'
Plug 'neovim/nvim-lspconfig'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'thaerkh/vim-workspace'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'vale1410/vim-minizinc'
"" Plug 'lervag/vimtex' " causes performance degradation
"" Plug 'easymotion/vim-easymotion'
"" Plug 'SirVer/ultisnips'
"" Plug 'honza/vim-snippets'
""Plug 'luochen1990/rainbow'
"" Plug 'scrooloose/nerdtree'
"" Plug 'madox2/vim-ai'
""
"" Plug 'inkarkat/argtextobj.vim'
""
"" Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer' }
"" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
"" Plug 'agude/vim-eldar' "color scheme eldar
"" Plug 'dense-analysis/ale'
"" Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
"" Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'} " 9000+ Snippets
"" Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
"" Plug 'neovim/nvim-lspconfig'
call plug#end()

" copilot setup
let g:copilot_filetypes = {
    \ 'tex': v:false,
    \ 'text': v:false,
    \ 'hotcrp_review': v:false,
    \ 'markdown': v:false,
    \ 'mail': v:false,
\ }


lua require'lspconfig'.pyright.setup{}

" COQ setup
" local lsp = require "lspconfig"
" local coq = require "coq" -- add this

" lsp.<server>.setup(<stuff...>)                              -- before
" lsp.<server>.setup(coq.lsp_ensure_capabilities(<stuff...>)) -- after

lua << EOF

-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
-- vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function ()
    vim.diagnostic.open_float(nil, {focus=false})
  end
})

EOF

" SpeedDating
augroup dateformats
	autocmd!
	autocmd VimEnter * silent execute 'SpeedDatingFormat %d.%m.%y'
	autocmd VimEnter * silent execute 'SpeedDatingFormat %d.%m.%Y'
	autocmd VimEnter * silent execute 'SpeedDatingFormat %d.\,%m.\,%y'
	autocmd VimEnter * silent execute 'SpeedDatingFormat %d.\,%m.\,%Y'
	autocmd VimEnter * silent execute 'SpeedDatingFormat %d.%m.%y'
	autocmd VimEnter * silent execute 'SpeedDatingFormat %d. %B %Y'
augroup END

" color scheme
"set background=dark
set termguicolors
"let g:neosolarized_contrast = "high"
"let g:neosolarized_visibility = "high"
"colorscheme NeoSolarized
colorscheme onehalfdark
let g:airline_theme='onehalfdark'
"let g:lightline.colorscheme='onehalfdark'

" wordcount
let g:word_count=wordcount().words
function WordCount()
    if has_key(wordcount(),'visual_words')
        let g:word_count=wordcount().visual_words."/".wordcount().words " count selected words
    else
        let g:word_count=wordcount().cursor_words."/".wordcount().words " or shows words 'so far'
    endif
    return g:word_count
endfunction

"lightline
let g:lightline = {
      \ 'colorscheme': 'onehalfdark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste', ],
      \             [ 'gitbranch', 'readonly', 'word_count', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" fugitive
let g:fugitive_gitlab_domains = ['https://extgit.iaik.tugraz.at', 'git.teaching.iaik.tugraz.at', 'git.losfuzzys.net']
let g:fugitive_legacy_commands = 0


set laststatus=2
set noshowmode

" YouCompleteMe
set completeopt-=preview
let g:ycm_folder='$HOME/.config/nvim/plugins/YouCompleteMe/'
let g:ycm_server_python_interpreter='/usr/bin/python3'

" ALE
let g:ale_linters = {'python': ['mypy'], 'tex': []}
" 
" nmap <silent> gd :ALEGoToImplementation<CR>
" nmap <silent> gD :ALEGoToDefinition<CR>
" nmap <silent> gr :ALEFindReferences<CR>

function SetCompleteMode(mode)
    if !exists('g:ycm_force_mode') || !g:ycm_force_mode
        let g:ycm_global_ycm_extra_conf=g:ycm_folder . "ycm_" . a:mode . ".py"
        if exists(':YcmRestartServer')
            YcmRestartServer
        endif
    endif
endfunction
command -nargs=* CompleteMode call SetCompleteMode(<f-args>)

" nmap <silent> <C-p> :FZF<CR>

" Ctrl-P
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=40
let g:ctrlp_working_path_mode = ""
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|Cache\|bundle'


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
autocmd Syntax mail set spell

set spelllang=en_us
hi clear SpellBad
hi clear SpellLocal
hi clear SpellRare
hi clear SpellCap
hi SpellBad gui=undercurl guisp=#e06c75
hi SpellCap gui=undercurl guisp=#61afef
hi SpellLocal gui=undercurl guisp=#e5c07b
hi SpellRare gui=undercurl guisp=#e5c07b


" smart case
set ignorecase
set smartcase

" vimtex
let g:tex_flavor = 'latex'

let g:latex_view_general_viewer = 'zathura'
let g:vimtex_view_method = "zathura"

let g:vimtex_compiler_progname = 'nvr' " neovim support

" quick fixes
let g:vimtex_quickfix_open_on_warning = 0


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


" vim commentary
autocmd FileType zinc setlocal commentstring=%\ %s
autocmd FileType cpp setlocal commentstring=//\ %s

" zinc highlight overlong

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

" vim ai
" custom command that provides a code review for selected code block
function! CodeReviewFn(range) range
  let l:prompt = "programming syntax is " . &filetype . ", review the code below"
  let l:config = {
  \  "options": {
  \    "initial_prompt": ">>> system\nyou are a clean code expert",
  \  },
  \}
  '<,'>call vim_ai#AIChatRun(a:range, l:config, l:prompt)
endfunction
command! -range CodeReview <line1>,<line2>call CodeReviewFn(<range>)

" easier terminal escape
tnoremap <Esc> <C-\><C-n>

" vim workspace
let g:workspace_session_disable_on_args = 1
let g:workspace_autosave = 0
let g:workspace_autosave_untrailspaces = 0
let g:workspace_session_directory = stdpath("data") . '/sessions/'
let g:workspace_undodir = stdpath("data") . '/undodir/'

" ignore most latex files for autocomplete
set wildignore+=*.pdf,*.o,*.o.d,*.obj,*.jpg,*.png
set wildignore+=*.aux,*.brf,*.xdv,*.bbl,*.blg,*.lof,*.toc,*.out,*.nav,*.snm,*.vrb,*.bcf,*.run.xml,*.acn,*.acr,*.alg,*.glg,*.glo,*.gls,*.idx,*.ilg,*.ind,*.nlo,*.nls,*.xdy,*.glsdefs,*.tps,*.tcp,*.lot,*.xwm,*.synctex.gz,*.fls,*.fdb_latexmk,*.auxlock,*.dpth,*.md5,*.pdf
set wildignore+=*.pdfpc,*.gnuplot,*.table
set suffixes+=*.bib,*.log, " autocomplete log files but only at the bottom

"FZF foo
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

autocmd Syntax cpp nmap <silent> <Leader>q :FSHere<cr>
autocmd Syntax cpp nmap <silent> <Leader>Q :FSTab<cr>
