set nocompatible " be iMproved, required

au! BufNewFile,BufRead gitconfig set syntax=gitconfig

" LaTeX file parsing
" au! BufNewFile,BufRead *.tex set filetype=tex


" TODO: Vundle stuff...
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')
" call vundle#begin()
"
" runtime ftplugin/man.vim
"
" " let Vundle manage Vundle, required
" Plugin 'VundleVim/Vundle.vim'
" Plugin 'jelera/vim-javascript-syntax'
" Plugin 'pangloss/vim-javascript'
" Plugin 'nathanaelkane/vim-indent-guides'
" Plugin 'fatih/vim-go'
"
" call vundle#end()


" A few functions I defined a million years ago and can't live without:
" Grep into the quickfix window:
command! -nargs=+ Gr execute 'silent grep! <args>' | copen 10 | normal 

" Re-check syntax on ^k
nnoremap <silent> <c-k> :syntax sync fromstart <CR>

" Run 'Make' into quickfix window and add some syntax highlighting
command! -nargs=? Ma execute 'make! <args>' | copen 10 | set syntax=make_out | set virtualedit= | 

" :Gg runs git-grep into the quickfix window
" No idea what this function is doing over just calling 'git grep'
" or why those lines are commented out...
function! Ggrep(arg)
  setlocal grepprg=git\ grep\ -n\ $*
  silent execute ':grep '.a:arg
  "setlocal grepprg=git\ --no-pager\ submodule\ --quiet\ foreach\ 'git\ grep\ --full-name\ -n\ --no-color\ $*\ ;true'
  "silent execute ':grepadd '.a:arg
  silent cwin
  redraw!
endfunction

command! -nargs=1 -complete=buffer Gg call Ggrep(<q-args>)

set t_Co=256

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backup		" keep a backup file

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" TODO: What is this doing??
" Don't use Ex mode, use Q for formatting
map Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
  set ttymouse=sgr
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
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

" I've been using this colorscheme for 12 years
" I see no reason to stop now
colorscheme jellybeans

" TODO: What is the '!' doing here?
set smartindent!
set tabstop=4
set shiftwidth=4
" Tabs become spaces
set expandtab

" Show line numbers
set number

" Double click to search for the term under the cursor
imap <2-LeftMouse> <c-o>*
map <2-LeftMouse> *

" ^C toggles line numbers so copying becomes a bunch easier
noremap  <c-c> :call ToggleCpy()<CR>
function ToggleCpy()
    if (&mouse == 'v')
        set nu
        set mouse=a
    else
        se nonu
        set mouse=v
    endif
endfunction

" \w toggles line wrapping on and off
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction

highlight ExtraWhitespace ctermbg=darkgray guibg=darkgray
match ExtraWhitespace /\s\+\%#\@<!$/

set colorcolumn=100

set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=1

