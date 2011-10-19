" tuned for 'light on dark' in an xterm session, using Rubymine
" keyboard shortcut conventions where possible to ease switch to/fro

" Basics {
  set nocompatible " explicitly get out of vi-compatible mode
  set background=dark " standard dark background
  syntax on " turn on syntax highlighting 
  " try remapping leader character - left little finger got tired of \t 
  let mapleader = "," 
" }

" General {
  filetype off " prep for loading using pathogen
  call pathogen#runtime_append_all_bundles() " initialise plugins using pathogen
  call pathogen#helptags() " update documentation for plugins
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

  " nice 'light on dark' colorscheme for 256 colour terminal
  if $TERM =~ "-256color"
    set t_Co=256
    colorscheme tir_black
    " make split windows more clearly defined
    hi StatusLineNC  guifg=darkgray guibg=#202020 ctermfg=235 ctermbg=darkgray
    " get folding summary lines to stand out more clearly
    hi Folded ctermfg=Gray
  endif
  
  " use peaksea for non-clashing colorscheme using vimdiff
  if &diff
    set t_Co=256
    colorscheme peaksea
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
  set number "turn on line numbering 

  " fugitive git status, full path, modified/readonly/help/preview flags,
  " number of lines, format, syntax, % into file, current line, current col
  set statusline=%{fugitive#statusline()}%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
  
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
      
      command! -nargs=* DebugPrint :RdbCommand p <args>
      map <leader>dp :DebugPrint

    endif
  "}

  "NERD_commenter
  map <Leader><Leader> <plug>NERDCommenterToggle
      

   " toggle NERDTree on/off with <Leader>1 (Rubymine style)
   nnoremap <Leader>1 <ESC>:NERDTreeToggle<RETURN>
   " experimental shortcut for finding current file in tree
   nnoremap <Leader>n <ESC>:NERDTreeToggleAndFind<RETURN>
   " put NERDTree on right
   let g:NERDTreeWinPos="right"
   " highlight selected entry in tree
   let NERDTreeHighlightCursorline=1
   
 
   " Taglist
   " toggle Tag List  on/off with <Leader>7 (Rubymine style)
   nnoremap <Leader>7 <ESC>:Tlist<RETURN>
	 let Tlist_Show_One_File = 1 " only display one file's tags at a time
   let Tlist_Use_Right_Window = 1 " prefer right-side windowing
   

   " Supertab
   let g:SuperTabDefaultCompletionType = "context"
   " turn off CR completion causing spurious text insertion clash with vim-endwise
   let g:SuperTabCrMapping = 0


   "Command-T
   map <Leader>t :CommandT<CR>
   let g:CommandTMaxHeight=15
   set wildignore+=.git
   
   " open in Tab with Ctl+Shift-T (in case Ctl+T overloaded by terminal app)
   let g:CommandTAcceptSelectionTabMap='<C-S-t>'  
   
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
   
   "MRU - <leader>e for RubyMine-like mapping of Ctl-E for recent file list
   nmap <Leader>e :MRU 
   
   "LustyJuggler for rapid buffer-switch
   nmap <Leader>j :LustyJuggler<cr>
   let g:LustyJugglerShowKeys = 'a'

   "show YankRing - somewhat like RubyMine Ctl-Shift-V to paste from buffers
   "(already shadowed by Konsole for pasting)
   nmap <Leader>v :YRShow<cr>

   "ConqueTerm
   function! SplitConsole(cmd)
     let term = conque_term#open(a:cmd,['below split','resize 10']) 
   endfunction
   command! -bar Scriptconsole :call SplitConsole('ruby script/console')
   command! -bar Irb :call SplitConsole('irb')
   command! -bar Mongrelrails :call SplitConsole('mongrel_rails start')
   command! -nargs=1 SplitConsole :call SplitConsole(<q-args>)

   "Session management
   let g:session_autoload = 1
   let g:session_autosave = 1

" }

