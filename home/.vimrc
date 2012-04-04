" tuned for 'light on dark' in an xterm session, using Rubymine
" keyboard shortcut conventions where possible to ease switch to/fro

" Basics {
  set nocompatible " explicitly get out of vi-compatible mode
  set background=dark " standard dark background
  syntax on " turn on syntax highlighting 
  " try remapping leader character - left little finger got tired of \t 
  let mapleader = "," 
" }

" Setup Bundle Support {
  " Using Vundle - see https://github.com/gmarik/vundle
  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()
"}

" Manage plugins using Vundle - e.g. :BundleInstall
" Bundles {

  " let Vundle manage Vundle, required
  Bundle 'gmarik/vundle'

  " Command-T file quick navigation
  " n.b. current need for manual installation after bundle installed
  " to manually make C extension: 
  "  'cd ~/.vim/ruby/command-t && ruby extconf.rb && make'
  "Bundle 'wincent/Command-T'

  " This fork is required due to remapping ; to :
  Bundle 'mutewinter/LustyJuggler'
  Bundle 'kien/ctrlp.vim'

  " UI Additions
  Bundle 'mutewinter/vim-indent-guides'
  Bundle 'scrooloose/nerdtree'
  Bundle 'tomtom/quickfixsigns_vim'
  Bundle 'bogado/file-line'
  "Bundle 'xolox/vim-easytags' 

  " Commands
  Bundle 'scrooloose/nerdcommenter'
  Bundle 'tpope/vim-surround'
  Bundle 'tpope/vim-unimpaired'
  Bundle 'tpope/vim-speeddating'
  Bundle 'tpope/vim-fugitive'
  Bundle 'godlygeek/tabular'
  Bundle 'mileszs/ack.vim'

  " Automatic Helpers
  Bundle 'xolox/vim-session'
  Bundle 'Raimondi/delimitMate'
  Bundle 'scrooloose/syntastic'
  Bundle 'ervandew/supertab'

  "Slime integration
  Bundle 'jpalardy/vim-slime'

  " Language Additions
  " Ruby
  Bundle 'vim-ruby/vim-ruby'
  Bundle 'tpope/vim-rails'
  Bundle 'tpope/vim-haml'
  Bundle 'tpope/vim-cucumber'
  Bundle 'tpope/vim-rake'
  Bundle 'rosenfeld/vim-ruby-debugger'
  "Bundle 'janx/vim-rubytest'

  " JavaScript
  Bundle 'pangloss/vim-javascript'
  Bundle 'kchmck/vim-coffee-script'
  Bundle 'leshill/vim-json'
  Bundle 'itspriddle/vim-jquery'

  " Other Languages
  Bundle 'mutewinter/nginx.vim'
  Bundle 'timcharper/textile.vim'
  Bundle 'ChrisYip/Better-CSS-Syntax-for-Vim'
  Bundle 'hallison/vim-markdown'

  " MatchIt
  Bundle 'matchit.zip'
  Bundle 'kana/vim-textobj-user'
  Bundle 'nelstrom/vim-textobj-rubyblock'

  " Libraries
  Bundle 'L9'
  Bundle 'tpope/vim-repeat'
  Bundle 'tomtom/tlib_vim'  

"}


" General {
  filetype off 
  filetype plugin indent on " load filetype plugin/indent settings
  set fileformats=unix,dos,mac " support all three, in this order
  set hidden " allow switch between buffers without prompt to save
  set directory=~$VIMRUNTIME/tmp//,~/tmp//,/var/tmp//,/tmp//
" }

" Text formatting/layout {
  set expandtab " convert tabs to spaces
  set shiftwidth=2 " auto-indent (and >> indenting)
  set softtabstop=2 " how many spaces for tab
  set tabstop=2 " how many spaces for tab
  set autoindent " copy indenting from current line when inserting new
  
" }

" Vim UI {

  " use dark colorscheme for 256 colour terminal
  if $TERM =~ "-256color"
    set t_Co=256
    set background=dark
    colorscheme tir_black
  endif

  " highlight text over 80 cols
  highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9 
  match OverLength /\%81v.\+/

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
  set number "turn on line numbering 

  " helper function for status line without errors on function calls
  " from https://github.com/tpope/tpope/raw/master/.vimrc
  function! SL(function)
    if exists('*'.a:function)
      return call(a:function,[])
    else
      return ''
    endif
  endfunction

  " fugitive git status, full path, modified/readonly/help/preview flags,
  " number of lines, format, syntax, % into file, current line, current col
  set statusline=%{SL('fugitive#statusline')}%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
  
  " make j/k navigate by screen line rather than file lines
  nnoremap j gj
  nnoremap k gk

  " overwrite standard scroll left/right to do larger movement as standard
  nnoremap zl zL 
  nnoremap zh zH

  " Use <F11> to toggle between 'paste' and 'nopaste'
  set pastetoggle=<F11>

  " mouse support {
    
    " disable mouse support by default
    set mouse=
    " support finegrained mouse position - required to resize window height/width
    set ttymouse=xterm2
    
    " toggle mouse support on/off (to be able to copy/paste text from screen) 
    function! ToggleMouse()
      if &mouse == 'a'
      set mouse=
      echo "Mouse usage disabled"
      else
      set mouse=a
      echo "Mouse usage enabled"
      endif
    endfunction
    nnoremap <F12> :call ToggleMouse()<Return>
  " }

" }

  " folding settings - from Bryan Liles  (http://smartic.us/2009/04/06/code-folding-in-vim/)
  set foldmethod=indent   "fold based on indent
  set foldnestmax=10      "deepest fold is 10 levels
  set nofoldenable        "dont fold by default
  set foldlevel=1         "this is just what i use

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
  nnoremap tt gt

  " set tj to go back ('down') to previous active tab
  let g:lasttab = 1
  nmap tj :exe "tabn ".g:lasttab<CR>
  au TabLeave * let g:lasttab = tabpagenr()
 
  "show numbers in tabline to do e.g. 4gt
  "script from http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
  "tweaked to add tab numbers and abbreviated path
  if exists("+showtabline")
    function! MyTabLine()
      let s = ''
      let t = tabpagenr()
      let i = 1
      while i <= tabpagenr('$')
        let buflist = tabpagebuflist(i)
        let winnr = tabpagewinnr(i)
        let s .= '%' . i . 'T'
        let s .= (i == t ? '%1*' : '%2*')
        let s .= ' '
        let s .= i . ':'
        let s .= '%*'
        let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
        let bufnr = buflist[winnr - 1]
        let file = bufname(bufnr)
        let buftype = getbufvar(bufnr, 'buftype')
        if buftype == 'nofile'
          if file =~ '\/.'
            let file = substitute(file, '.*\/\ze.', '', '')
          endif
        else
          let file = pathshorten(fnamemodify(file, ':p:.'))
        endif
        if file == ''
          let file = '[No Name]'
        endif
        let s .= file
        let bufmodified = getbufvar(bufnr, "&mod")
        if bufmodified
          let s .= '*'
        endif
        let s .= ""
        let i = i + 1
      endwhile
      let s .= '%T%#TabLineFill#%='
      let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
      return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
  endif

  " move Windows between tabs - from 
  " http://vim.wikia.com/wiki/Move_current_window_between_tabs
  
  function! MoveToPreviousTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
      return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() != 1
      close!
      if l:tab_nr == tabpagenr('$')
        tabprev
      endif
      sp
    else
      close!
      exe "0tabnew"
    endif
    "opening current buffer in new window
    exe "b".l:cur_buf
  endfunc

  function! MoveToNextTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
      return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() < tab_nr
      close!
      if l:tab_nr == tabpagenr('$')
        tabnext
      endif
      sp
    else
      close!
      tabnew
    endif
    "opening current buffer in new window
    exe "b".l:cur_buf
  endfunc
  
  nnoremap <C-W>. :call MoveToNextTab()<CR>
  nnoremap <C-W>, :call MoveToPreviousTab()<CR>

" }

" RubyMine style forward/back history navigation {
    map <C-left> <C-O>
    map <C-right> <C-I>
" }

" Tag navigation

   " give Ctl-] :tjump behaviour (i.e. show list in case multiple matches)
   nnoremap <c-]> g<c-]>
   vnoremap <c-]> g<c-]>


" Editing {

    " move lines and visual blocks up and down (Ctl+Shift+up/down RubyMine style)
    nnoremap <C-down> :m+<CR>==
    nnoremap <C-up> :m-2<CR>==
    inoremap <C-down> <Esc>:m+<CR>==gi
    inoremap <C-up> <Esc>:m-2<CR>==gi
    vnoremap <C-down> :m'>+<CR>gv=gv
    vnoremap <C-up> :m-2<CR>gv=gv

    " indent/dedent using TAB/Shift-Tab (RubyMine style) in visual mode
    vmap <TAB> >gv
    vmap <S-TAB> <gv

" }

"" Misc Mappings {
  
"  " remap 'jj' in Insert mode to escape to Normal mode
  inoremap jj <ESC>

  " make ; a synonym for : in normal mode
  nnoremap ; :
  
  " remapping to jump to line *and column* for marks
  nnoremap ' `
  nnoremap ` '

  " Edit vimrc \ev  then source changes with \sv
  nnoremap <silent> <Leader>ev :e ~/.vimrc<CR>
  nnoremap <silent> <Leader>sv :so ~/.vimrc<CR>

  " allow sudo writing of file overriding original permissions on editing
  command! -bar -nargs=0 SudoW   :setl nomod|silent exe 'write !sudo tee % >/dev/null'|let &mod = v:shell_error

" }

" Ruby/Rails { 
  iabbrev rdebug    require 'ruby-debug'; require 'ruby-debug/pry'; Debugger.start; Debugger.settings[:autoeval] = 1; Debugger.settings[:autolist] = 1; debugger #DEBUG
"}

" Plugin config {
  
  "Ack - installed to ~/bin per: 
  "  curl http://betterthangrep.com/ack-standalone > ~/bin/ack && chmod 0755 !#:3
  nnoremap <Leader>a :Ack --nosql

  " Ruby Debugger {
    if exists("g:RubyDebugger")
      
      command! -nargs=* DebugPrint :RdbCommand p <args>
      map <leader>dp :DebugPrint

    endif
  "}

  "NERD_commenter
  map <Leader><Leader> <plug>NERDCommenterToggle
      
   " toggle NERDTree on/off with <Leader>1 (Rubymine style)
   nnoremap <Leader>1 <ESC>:NERDTreeToggle<RETURN>
   nnoremap <Leader>f <ESC>:NERDTreeFind<RETURN>
   " put NERDTree on right
   let g:NERDTreeWinPos="right"
   " highlight selected entry in tree
   let NERDTreeHighlightCursorline=1
   
 
   " Tagbar
   " toggle Tagbar  on/off with <Leader>7 (Rubymine style)
   nnoremap <Leader>7 <ESC>:TagbarToggle<RETURN>

   " Supertab
   let g:SuperTabDefaultCompletionType = "context"
   " turn off CR completion causing spurious text insertion clash with vim-endwise
   let g:SuperTabCrMapping = 0

   "CtrlP

   "Command-T mapping to invoke CtrlP
   map <Leader>t :CtrlP<CR>

   " open MRU list
   map <Leader>em :CtrlPMRU<CR>
   " open directory containing current file
   map <Leader>ef :CtrlPCurFile<CR>
   " find based on current working directory
   map <Leader>ed :CtrlPCurWD<CR>
   " find current buffers
   map <Leader>eb :CtrlPBuffer<CR>

   let g:ctrlp_max_height = 15
   let g:ctrlp_custom_ignore='.git'
   
   " Fugitive
   nmap <Leader>gs :Gstatus<cr>
   nmap <Leader>gc :Gcommit<cr>
   nmap <Leader>ga :Gwrite<cr>
   nmap <Leader>gl :Glog<cr>
   nmap <Leader>gd :Gdiff<cr>
   " shorthand for pull with rebase
   autocmd User Fugitive command! -bang -bar -buffer -nargs=* Gpr :Git<bang> pull --rebase <args>
   
   " Gitv
   nmap <leader>gv :Gitv --all<cr>
   nmap <leader>gV :Gitv! --all<cr>
   vmap <leader>gV :Gitv! --all<cr>
   
   "LustyJuggler for rapid buffer-switch
   nmap <Leader>j :LustyJuggler<cr>
   let g:LustyJugglerShowKeys = 'a'
   let g:LustyExplorerSuppressRubyWarning = 1

  "Session management
   let g:session_autoload = 1
   let g:session_autosave = 1
 
  "Tabular for code alignment
  if exists(":Tabularize")
    nmap <Leader>l= :Tabularize /=<CR>
    vmap <Leader>l= :Tabularize /=<CR>
    nmap <Leader>l] :Tabularize /=><CR>
    vmap <Leader>l] :Tabularize /=><CR>
    nmap <Leader>l- :Tabularize /-<CR>
    vmap <Leader>l- :Tabularize /-<CR>
    nmap <Leader>l: :Tabularize /:\zs<CR>
    vmap <Leader>l: :Tabularize /:\zs<CR>
  endif

  "Ruby-test
   map <Leader>n <Plug>RubyTestRun
   map <Leader>N <Plug>RubyFileRun
   map <Leader>m <Plug>RubyTestRunLast

   " hack for slime integration
   let g:rubytest_via_slime = 1

   function! ToggleTest()
      if exists("g:quick_test") && g:quick_test != ""
        let g:rubytest_cmd_test = "ruby %p"
        let g:rubytest_cmd_testcase = "ruby %p -n '/%c/'"
        let g:quick_test=""
        echo "quick_test disabled"
      else
        "TODO allow localisation of ruby_fork_client reference?
        let g:rubytest_cmd_test = "ruby ~/git/PAM/script/dev/ruby_fork_client %p"
        let g:rubytest_cmd_testcase = "ruby ~/git/PAM/script/dev/ruby_fork_client -r %p -n '/%c/'"
        let g:quick_test=1
        echo "quick_test enabled"
      endif
   endfunction
   " disable quick_test initially
   "nnoremap <Leader> :call ToggleTest()<Return>
   let g:rubytest_in_quickfix = 0

" }

" localise {
  runtime .local.vimrc
" }

