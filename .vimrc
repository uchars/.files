" Defaults
let mapleader = " "
syntax on
colorscheme retrobox
set background=dark
set relativenumber
set colorcolumn=120
set splitbelow splitright
set number
set encoding=utf-8
set backspace=indent,eol,start
set belloff=all
set incsearch
set termguicolors
set timeoutlen=500
set updatetime=50
set signcolumn=yes
set scrolloff=8
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smartindent
set autoindent
set hlsearch
set completeopt=menuone,noselect

" Keymaps
tnoremap <Esc> <C-\><C-n>
tnoremap <C-r> <C-r>
nnoremap <silent> <C-b> :Ex<CR>
nnoremap <C-p> :find<Space>
nnoremap <silent> <leader>i :so %<CR>
vnoremap <silent> <leader>y "+y
nnoremap <silent> <leader>Y gg"+yG
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

if has("unix")
  runtime! ftplugin/man.vim
  set keywordprg=:Man " Open Man page inside buffer
endif

" Undo Stuff
set nobackup
set undodir=~/.vim/undodir
set undofile
set noswapfile

" Plugin loading
if isdirectory(expand('$HOME/.vim/pack/plugins/start/vim-fugitive'))
    execute 'set runtimepath+=' . expand('$HOME/.vim/pack/plugins/start/vim-fugitive')
    nnoremap <silent> <leader>gs :Git<CR>
endif

" Custom commands
command! W w
command! Wqa wqa
command! Wq wq
command! Dot :e $MYVIMRC
command! Rc :e $MYVIMRC
command! RC :e $MYVIMRC
command! Tags !ctags -R .
command! MakeTags !ctags -R .

" Auto commands
augroup FormatGroup
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END
autocmd FileType * setlocal formatoptions-=cro

" Search
set path+=**
set wildmenu
nnoremap <C-p> :find<Space>
nnoremap <Space><Space> :ls<CR>:b<Space>

" Navigation
nnoremap gt <C-]>
nnoremap gT g]
nnoremap gd <C-]>
nnoremap <silent> <C-k><C-o> :call ToggleHeaderSource()<CR>

" Statusline
set laststatus=2
set statusline=%{GitBranch()} " Git branch
set statusline+=%{GitChanges()} " Git changes
set statusline+=%{pathshorten(expand('%:p:.'))} " compact filename
set statusline+=\ %m " Modified
set statusline+=%= " Space until end
set statusline+=%y " Filetype
set statusline+=\ %l:%c " line and column

" ======= Functions

function! GitChanges()
  if exists('*FugitiveHead') && FugitiveGitDir() !=# ''
    let l:stats = FugitiveExecute(['diff', '--shortstat']).stdout
    if empty(l:stats)
      return ''
    endif
    let l:added   = matchstr(l:stats, '\d\+ insertions*(+)*')
    let l:deleted = matchstr(l:stats, '\d\+ deletions*(\-)*')
    let l:changes = '('
    if !empty(l:added)
      let l:changes .= '+' . substitute(l:added, '\D', '', 'g')
    endif
    if !empty(l:deleted)
      let l:changes .= '-' . substitute(l:deleted, '\D', '', 'g')
    endif
    let l:changes .= ') '
    return l:changes
  endif
  return ''
endfunction

function! GitBranch()
  if exists('*FugitiveHead') && FugitiveGitDir() !=# ''
    let l:branch = FugitiveHead()
    return empty(l:branch) ? '' : '[' . l:branch . ']'
  endif
  return ''
endfunction

function! ToggleHeaderSource()
  let l:file = expand('%:t')
  let l:dir  = expand('%:p:h')

  let l:ext_map = {
        \ 'cpp': 'h',
        \ 'cc': 'hpp',
        \ 'h': 'cpp',
        \ 'hpp': 'cc'
        \ }

  let l:cur_ext = expand('%:e')
  if !has_key(l:ext_map, l:cur_ext)
    echo "No corresponding header/source defined for this extension"
    return
  endif

  let l:target_ext = l:ext_map[l:cur_ext]
  let l:base = expand('%:t:r')  " filename without extension
  let l:candidates = []
  call add(l:candidates, l:dir . '/' . l:base . '.' . l:target_ext)
  let l:root = l:dir
  while l:root !=# '/' && !isdirectory(l:root . '/include')
    let l:root = fnamemodify(l:root, ':h')
  endwhile
  if isdirectory(l:root . '/include')
    call add(l:candidates, l:root . '/include/' . l:base . '.' . l:target_ext)
  endif

  " Try to open the first existing file
  for f in l:candidates
    if filereadable(f)
      execute 'edit' fnameescape(f)
      return
    endif
  endfor

  echo "No matching file found for " . l:base . "." . l:target_ext
endfun

" === Plugin stuff
command! Gitinstall call Gitinstall()

function! Gitinstall()
    let l:fugitive_path = expand('$HOME/.vim/pack/plugins/start/vim-fugitive')
    if !isdirectory(l:fugitive_path)
        echo "Installing vim-fugitive..."
        silent !git clone https://github.com/tpope/vim-fugitive.git $HOME/.vim/pack/plugins/start/vim-fugitive
        execute 'helptags' l:fugitive_path.'/doc'
        echo "vim-fugitive installed!"
    else
        echo "vim-fugitive already installed."
    endif
endfunction
