" A vimrc file. Taken from Bram Moolenar's Example
"
" Maintainer:	Rajiv palayan <rajivpalayan@gmail.com>
" Last change:	2015 Feb 16
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set ignorecase
set smartcase

set nobackup		" do not keep a backup file, use versions instead
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

set autochdir

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  execute pathogen#infect()
  syntax on
  map <C-n> :NERDTreeToggle<CR>
  set hidden
  set nu
  "Move between Buffers
  nnoremap <F9>    :bprevious<CR>
  nnoremap <F10>   :bnext<CR>
  nnoremap <F5>    :buffers<CR>:b
  "Move between Tags
  nnoremap <S-F9>  :tprevious<CR>
  nnoremap <S-F10> :tnext<CR>
  nnoremap <S-F5>  :tags
  "Add and delete Buffers
  nnoremap <S-F11> :badd
  nnoremap <F12>   :bdelete %<CR>
  nnoremap <S-F12> :bdelete
  nnoremap <F11>   :e 
  "Refreshing Buffers
  nnoremap <F4>    :e<CR>
  "Searching
  nnoremap <F2>    *``
  "Title
  nnoremap <S-F2>  :set titlestring=
  "VIMGREP
  nnoremap <F3>    :cn<CR>
  nnoremap <S-F3>  :cp<CR>
  nnoremap <S-F4>  :cexpr []<CR>:let curr_buf=bufnr('%') \| bufdo vimgrepadd /PATTERN/j % \| execute 'buffer' curr_buf
  set hlsearch
  set title
  set visualbell
  set tabpagemax=20
  set wrap
  set linebreak
  set nolist
  set showbreak=>\
  set textwidth=0
  set wrapmargin=0
  set updatecount=0
" For Xterm
" let &t_SI = "\x1b[\x30 q"
" let &t_EI = "\x1b[\x32 q"
" For KDE4 Konsole
" let &t_SI = "\<Esc>]50;CursorShape=1\x7"
" let &t_SR = "\<Esc>]50;CursorShape=2\x7"
" let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

if has("gui_running")
  set guifont=monospace\ 14
  set background=dark
  colorscheme solarized
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 79 characters.
  autocmd FileType text setlocal textwidth=79

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"Do not automatically open folds when searching
set foldopen-=search

" virtual tabstops using spaces
set shiftwidth=2
set softtabstop=2
set noexpandtab
" allow toggling between local and default mode
function TabToggle()
  if &expandtab
    set shiftwidth=4
    set softtabstop=0
    set noexpandtab
  else
    set shiftwidth=2
    set softtabstop=2
    set expandtab
  endif
endfunction
nmap <S-F9> mz:execute TabToggle()<CR>'z


function! Incr()
  let a = line('.') - line("'<")
  let c = virtcol("'<")
  if a > 0
    execute 'normal! '.c.'|'.a."\<C-a>"
  endif
  normal `<
endfunction
vnoremap <C-a> :call Incr()<CR>

function! Decr()
  let x = line('.') - line("'<")
  let c = virtcol("'<")
  if x > 0
    execute 'normal! '.c.'|'.x."\<C-x>"
  endif
  normal `<
endfunction
vnoremap <C-x> :call Decr()<CR>
map  :w!<CR>
map  :source ~/.vimrc<CR>
nmap <C-Q> :q<CR>

set tags=./tags;,tags;

"matchit
"will work on vim 7.4
source $VIMRUNTIME/macros/matchit.vim
"will work vim 8.0 and higher only
"packadd! matchit

"Rajiv Adding auto commands for updating C file header text automatically
autocmd bufnewfile *.c so /home/rajiv/c_header.txt
autocmd bufnewfile *.c exe "1," . 6 . "g/File Name      :.*/s//File Name      : " .expand("%")
autocmd bufnewfile *.c exe "1," . 6 . "g/Created On     :.*/s//Created On     : " .strftime("%d-%m-%Y")
autocmd Bufwritepre,filewritepre *.c execute "normal ma"
autocmd Bufwritepre,filewritepre *.c exe "1," . 6 . "g/Last Modified  :.*/s/Last Modified  :.*/Last Modified  : " .strftime("%c")
autocmd bufwritepost,filewritepost *.c execute "normal `a"

"Airline settings
let g:airline_theme='dark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline#extensions#tabline#buffer_nr_show = 1

"Easy-align plugin
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
