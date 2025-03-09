" Set leader key to space
let mapleader = " "

" Set highlight on search
set nohlsearch

" Set scrolloff
set scrolloff=8

" Make line numbers default
set number
set relativenumber

" Set tab settings
set tabstop=2
set shiftwidth=2
set expandtab

" Enable mouse mode
set mouse=a

" Enable break indent
set breakindent
set guicursor=

" Save undo history
set nobackup
set undodir=~/.vim/undodir
set undofile
set noswapfile

" Case-insensitive searching UNLESS \C or capital in search
set ignorecase
set smartcase

" Keep signcolumn on by default
set signcolumn=yes

" Decrease update time
set updatetime=50

" Set completeopt to have a better completion experience
set completeopt=menuone,noselect

" Enable true color support
set termguicolors

" Basic Keymaps
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>

" Remap for dealing with word wrap
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Highlight on yank
augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END

" Remove trailing whitespace on save
augroup FormatGroup
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END

" Disable automatic comment insertion
autocmd FileType * setlocal formatoptions-=cro

" Set filetype for Dockerfiles
autocmd BufNewFile,BufRead Dockerfile* set filetype=Dockerfile

" Center screen when scrolling
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

" Move lines up and down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Quickfix navigation
nnoremap <C-k> :cnext<CR>zz
nnoremap <C-j> :cprev<CR>zz

" Save file with Ctrl+S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Copy paste
xnoremap <leader>p "_dP
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" Terminal keymap
tnoremap <Esc> <C-\><C-n>
tnoremap <C-r> <C-r>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Insert umlauts
nnoremap ;a aä<ESC>
nnoremap ;o aö<ESC>
nnoremap ;u aü<ESC>

" Custom command for saving
command! W w

" File explorer
nnoremap <C-b> :Ex<CR>

" Tab navigation
nnoremap <Left> gT
nnoremap <Right> gt

" Buffer navigation
nnoremap <Up> :bnext<CR>
nnoremap <Down> :bprev<CR>

set background=dark
" colorscheme gruvbox
