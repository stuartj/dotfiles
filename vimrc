" Basics {
  set nocompatible " explicitly get out of vi-compatible mode
  set background=dark " standard dark background
  syntax on " turn on syntax highlighting
" }

" General {
  filetype off " prep for loading using pathogen
  call pathogen#runtime_append_all_bundles() " initialise plugins using pathogen
  call pathogen#helptags() " update documentation for plugins
  filetype plugin indent on " load filetype plugin/indent settings
  set fileformats=unix,dos,mac " support all three, in this order
  set hidden " allow switch between buffers without prompt to save
" }

" Text formatting/layout {
  set expandtab " convert tabs to spaces
  set shiftwidth=2 " auto-indent (and >> indenting)
  set softtabstop=2 " how many spaces for tab
  set tabstop=2 " how many spaces for tab
  set autoindent " copy indenting from current line when inserting new
" }

" Vim UI {

  " nice colorscheme 
  if $TERM =~ "-256color"
    set t_Co=256
    colorscheme tir_black
  endif
 
  " search settings
  set ignorecase " case insensitive searches by default
  set smartcase " override case insensitive searches if search phrase includes capital letters
  set showmatch " show matches as typing
  set incsearch " highlight as typing search phrase
  set hlsearch " highlight matched search phrase
  
  " turn off highlighting easily with \<space>
  nnoremap <Leader><space> :noh<cr> 

  set gdefault " default to appending /g for substitutions (append manually to turn *off*)
  " fix Vim regex handling to use normal Perl-style regex 
  nnoremap / /\v
  vnoremap / /\v 
  
  set cursorline " highlight current line
  set scrolloff=3 " maintain offset of 3 lines when scrolling
  set laststatus=2 " always show the status line
  set nonumber "turn off line numbering 

  " fugitive git status, full path, modified/readonly/help/preview flags,
  " number of lines, format, syntax, % into file, current line, current col
  set statusline=%{fugitive#statusline()}%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
  
  " make j/k navigate by screen line rather than file lines
  nnoremap j gj
  nnoremap k gk

  " Use <F11> to toggle between 'paste' and 'nopaste'
  set pastetoggle=<F11>

" }

" Window and Tab management {

  " make '\w' open a vertical split and change to it
  nnoremap <Leader>w <C-w>v<C-w>l 

  " switch splits by Ctl+ motion (no Ctl+w chord)
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l
  
  " tab navigation/control 
  " (firefox-style C-tab won't work in terminal)
  nnoremap tl :tabnext<CR>
  nnoremap th :tabprev<CR>
  nnoremap tn :tabnew<CR>
  nnoremap td :tabclose<CR>
  
" }

" Navigation {
    map <C-left> <C-O>
    map <C-right> <C-I>
" }

"" Misc Mappings {
  
"  " remap 'jj' in Insert mode to escape to Normal mode
  inoremap jj <ESC>

  " make ; a synonym for : in normal mode
  nnoremap ; :
  
  " remapping to jump to line *and column* for marks
  nnoremap ' `
  nnoremap ` '

  " Edit vimrc \ev
  nnoremap <silent> <Leader>ev :tabnew<CR>:e ~/.vimrc<CR>

  " Make Arrow Keys Useful Again {
      " next buffer and previous buffers
      map <left> <ESC><C-6><RETURN>
  " }

" }

" Ruby/Rails { 
  iabbrev rdebug    require 'ruby-debug'; Debugger.start; Debugger.settings[:autoeval] = 1; Debugger.settings[:autolist] = 1; debugger #DEBUG
"}

" Plugin config {
  
  " N.B. plugins mostly installed as submodules using pathogen
  " - initialise and update plugins using 'git submodule update --init'
  "
  " BUT Command-T installed standalone - need to  make C extension: 
  "  'cd ~/.vim/ruby/command-t && ruby extconf.rb && make'
  
  "Ack - installed to ~/bin per: 
  "  curl http://betterthangrep.com/ack-standalone > ~/bin/ack && chmod 0755 !#:3
  nnoremap <Leader>a :Ack --nosql

  " Ruby Debugger {
    if exists("g:RubyDebugger")
      " n.b. mappings actually changed per these mappings in
      " bundle/vim-ruby-debugger/plugin/ruby_debugger.vim 
      " (couldn't find a neat way to undo noremap)
      map <Leader>db :call g:RubyDebugger.toggle_breakpoint()<CR>
      map <Leader>dv :call g:RubyDebugger.open_variables()<CR>
      map <Leader>dm :call g:RubyDebugger.open_breakpoints()<CR>
      map <Leader>dt :call g:RubyDebugger.open_frames()<CR>
      map <Leader>ds :call g:RubyDebugger.step()<CR>
      map <Leader>df :call g:RubyDebugger.finish()<CR>
      map <Leader>dn :call g:RubyDebugger.next()<CR>
      map <Leader>dc :call g:RubyDebugger.continue()<CR>
      map <Leader>de :call g:RubyDebugger.exit()<CR>
      map <Leader>dd :call g:RubyDebugger.remove_breakpoints()<CR>
    endif
  "}

  "NERD_commenter
  map <Leader><Leader> <plug>NERDCommenterToggle
      
   " toggle NERDTree on/off with <Leader>1 (Rubymine style)
   nnoremap <Leader>1 <ESC>:NERDTreeFind<RETURN>
   let g:NERDTreeWinPos="right"
   " toggle Tag List  on/off with <Leader>7 (Rubymine style)
   nnoremap <Leader>7 <ESC>:Tlist<RETURN>

   " Supertab
   let g:SuperTabDefaultCompletionType = "context"

   "Command-T
   map <Leader>t :CommandT<CR>
   let g:CommandTMaxHeight=15
   set wildignore+=.git

   " Fugitive
   nmap <Leader>gs :Gstatus<cr>
   nmap <Leader>gc :Gcommit<cr>
   nmap <Leader>ga :Gwrite<cr>
   nmap <Leader>gl :Glog<cr>
   nmap <Leader>gd :Gdiff<cr>

   "MRU - \e for RubyMine-like mapping of recent file list
   nmap <Leader>e :MRU<cr>

" }

