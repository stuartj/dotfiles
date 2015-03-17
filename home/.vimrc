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
  let g:vundle_default_git_proto = 'https'
  call vundle#rc()
"}

" Manage plugins using Vundle - e.g. :BundleInstall
" Bundles {

  " let Vundle manage Vundle, required
    Bundle 'gmarik/vundle'

  " Git
    Bundle 'tpope/vim-fugitive'
       " Fugitive
       nmap <Leader>gs :Gstatus<cr>
       nmap <Leader>gc :Gcommit<cr>
       nmap <Leader>ga :Gwrite<cr>
       nmap <Leader>gl :Glog<cr>
       nmap <Leader>gd :Gdiff<cr>

       " manage 3-way diff with fugitive
       " n.b. set up git mergetool with
       "   git config --global mergetool.fugitive.cmd 'vim -f -c "Gdiff" "$MERGED"'
       "   git config --global mergetool fugitive
         nnoremap <Leader>g2 :diffget //2<CR>:diffupdate<CR>
         nnoremap <Leader>g3 :diffget //3<CR>:diffupdate<CR>
         nnoremap <Leader>gq :Gwrite<CR>:qa<CR>

       " shorthand for pull with rebase
       autocmd User Fugitive command! -bang -bar -buffer -nargs=* Gpr :Git<bang> pull --rebase <args>


    Bundle 'int3/vim-extradite'
       "Extradite - mnemonic 'git history'
       nmap <Leader>gh :Extradite<cr>


    " Ctrl-P for file search
    Bundle 'kien/ctrlp.vim'
      if executable('ag')
        echom "using ag for ctrlp..."
        let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
              \ --ignore .git
              \ --ignore "**/*.sql"
              \ --ignore "**/*.log"
              \ -g ""'
      endif
      " faster matching than default vimscript
      Bundle 'FelikZ/ctrlp-py-matcher'
      "let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
  " UI Additions
    Bundle 'mutewinter/vim-indent-guides'
    Bundle 'scrooloose/nerdtree'
    Bundle 'tomtom/quickfixsigns_vim'
      " disable VCS marks to integrate with gitgutter
      let g:quickfixsigns_classes = ['qfl','loc','marks','breakpoints']
    Bundle 'airblade/vim-gitgutter'
      nmap ]c <Plug>GitGutterNextHunk
      nmap [c <Plug>GitGutterPrevHunk

     " Tagbar
     " toggle Tagbar  on/off with <Leader>7 (Rubymine style)
     nnoremap <Leader>7 <ESC>:TagbarToggle<RETURN>

  " Opening files
    Bundle 'bogado/file-line'
    Bundle 'yokomizor/LocateOpen'

  " Commands
    Bundle 'scrooloose/nerdcommenter'
      "NERD_commenter
      map \\ <plug>NERDCommenterToggle

       " toggle NERDTree on/off with <Leader>1 (Rubymine style)
       nnoremap <Leader>1 <ESC>:NERDTreeToggle<RETURN>
       nnoremap <Leader>f <ESC>:NERDTreeFind<RETURN>
       " put NERDTree on right
       let g:NERDTreeWinPos="right"
       " highlight selected entry in tree
       let g:NERDTreeHighlightCursorline=1
       " don't hijack netrw while evaluating vim-vinegar
       let NERDTreeHijackNetrw=0

    Bundle 'tpope/vim-vinegar'

    Bundle 'tpope/vim-surround'
    Bundle 'tpope/vim-unimpaired'
    Bundle 'tpope/vim-speeddating'
    Bundle 'junegunn/vim-easy-align'
      " Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
      vmap <Enter> <Plug>(EasyAlign)

      " Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
      nmap <Leader>a <Plug>(EasyAlign)

    Bundle 'mileszs/ack.vim'
      "Ack - installed to ~/bin per:
      "  curl http://betterthangrep.com/ack-standalone > ~/bin/ack && chmod 0755 !#:3
      nnoremap <Leader>a :Ack
        if executable('ag')
         " use ag if possible for grep
         let g:ackprg = 'ag --nogroup --nocolor --column'
        endif

    " adds Qdo command for argdo over quickfix matches
    Bundle 'henrik/vim-qargs'


  " Automatic Helpers
    Bundle 'xolox/vim-misc'
    Bundle 'xolox/vim-session'
    Bundle 'scrooloose/syntastic'
      let g:syntastic_ruby_checkers = ['rubocop']

    Bundle 'ervandew/supertab'
       " Supertab
       let g:SuperTabDefaultCompletionType = "context"
       " turn off CR completion causing spurious text insertion clash with vim-endwise
       let g:SuperTabCrMapping = 0


  " Tmux integration
    Bundle 'christoomey/vim-tmux-navigator'
    Bundle 'benmills/vimux'
    Bundle 'pgr0ss/vimux-ruby-test'
      let g:vimux_ruby_cmd_unit_test = "bundle exec ruby"
      let g:vimux_ruby_cmd_all_tests = "bundle exec ruby"
      let g:vimux_ruby_cmd_context = "bundle exec ruby"
       map <Leader>n :RunRubyFocusedTest<CR>
       map <Leader>c :RunRubyFocusedContext<CR>
       map <Leader>N :RunAllRubyTests<CR>
       map <Leader>m :VimuxRunLastCommand<CR>

  " Language Additions
  " Ruby
    Bundle 'vim-ruby/vim-ruby'
      " Ruby Debugger {
        if exists("g:RubyDebugger")

          command! -nargs=* DebugPrint :RdbCommand p <args>
          map <leader>dp :DebugPrint

        endif
      "}

    Bundle 'tpope/vim-rails'
      " convenience alias so no need to shift case for vertical split
      " alternate file
      cabbrev av <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'AV' : 'av')<CR>

    Bundle 'tpope/vim-haml'
    Bundle 'tpope/vim-cucumber'
    Bundle 'tpope/vim-rake'
    Bundle 'rosenfeld/vim-ruby-debugger'
    Bundle 'tpope/vim-bundler'
    Bundle 't9md/vim-chef'
    Bundle 'tpope/gem-ctags'
    Bundle 'tpope/vim-projectile'
    Bundle 'tpope/vim-rake'
    Bundle 'ecomba/vim-ruby-refactoring'
     vnoremap <leader>rel :RExtractLocalVariable<cr>
     vnoremap <leader>riv :RExtractInstanceVariable<cr>
     vnoremap <leader>rem :RExtractMethod<cr>

  " Databases
    Bundle 'vim-scripts/dbext.vim'
     " MySQL configuration example - override in .local.vimrc
     let g:dbext_default_profile_mysql_local = 'type=MYSQL:user=example_user:passwd=example_password:dbname=example_database'


  " JavaScript
    Bundle 'pangloss/vim-javascript'
    Bundle 'kchmck/vim-coffee-script'
    Bundle 'leshill/vim-json'
    Bundle 'itspriddle/vim-jquery'

  " Other Languages
  " Other File Formats
    Bundle 'mutewinter/nginx.vim'
    Bundle 'timcharper/textile.vim'
    Bundle 'ChrisYip/Better-CSS-Syntax-for-Vim'
    Bundle 'hallison/vim-markdown'
    Bundle 'chrisbra/csv.vim'

  " MatchIt
    Bundle 'matchit.zip'
    Bundle 'kana/vim-textobj-user'
    Bundle 'nelstrom/vim-textobj-rubyblock'

  " Libraries
    Bundle 'L9'
    Bundle 'tpope/vim-repeat'
    Bundle 'tomtom/tlib_vim'

  " Window management
    Bundle 'vim-scripts/ZoomWin'

  " Tab management
    Bundle 'gcmt/taboo.vim'
      let g:taboo_tab_format = '[%N] %f%m '
      let g:taboo_renamed_tab_format = '[%N] <%l>%m '
      let g:taboo_tabline = 1

  " UI enhancements
    Bundle 'nathanaelkane/vim-indent-guides'
      " n.b. default mapping is <Leader>ig

      " override for alternate light and dark 'soft black' guides
      let g:indent_guides_auto_colors = 0
      autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=237
      autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=235

      Bundle 'kien/rainbow_parentheses.vim'
      au VimEnter * RainbowParenthesesToggle
      au Syntax * RainbowParenthesesLoadRound
      au Syntax * RainbowParenthesesLoadSquare
      au Syntax * RainbowParenthesesLoadBraces

    Bundle 'sjl/gundo.vim'
      nnoremap <F5> :GundoToggle<CR>

  " Other plugins (not installed via Vundle) {

      "Session management
       let g:session_autoload = 1
       let g:session_autosave = 'no'

  "}

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

  " strip trailing white space before each buffer write
  autocmd BufWritePre * :%s/\s\+$//e

" }

" Vim UI {

  " use dark colorscheme for 256 colour terminal
  if $TERM =~ "-256color"
    set t_Co=256
    " fix black background display not rendering properly in tmux/screen
    set term=screen-256color
    colorscheme Monokai
  endif

  " column 80 highlighting {

    " highlight text over 80 cols
    "highlight OverLength ctermbg=darkred ctermfg=white guibg=#FFD9D9
    "match OverLength /\%81v.\+/

    " toggle colorcolumn on and off.
    " from http://pastebin.com/NRRTKe1m
    "
    " If colorcolumn is off and textwidth is set the use colorcolumn=+1.
    " If colorcolumn is off and textwidth is not set then use colorcolumn=80.
    " If colorcolumn is on then turn it off.

    function! ColorColumn()
      if empty(&colorcolumn)
        if empty(&textwidth)
          echo "colorcolumn=80"
          setlocal colorcolumn=80
        else
          echo "colorcolumn=+1 (" . (&textwidth + 1) . ")"
          setlocal colorcolumn=+1
        endif
      else
        echo "colorcolumn="
        setlocal colorcolumn=
      endif
    endfunction

    nmap <Leader>co :call ColorColumn()<CR>

  " }

  " search settings
  set ignorecase " case insensitive searches by default
  set smartcase " override case insensitive searches if search phrase includes capital letters
  set showmatch " show matches as typing
  set incsearch " highlight as typing search phrase
  set hlsearch " highlight matched search phrase

  "unsets the "last search pattern" register by hitting return
  nnoremap <CR> :noh<CR><CR>

  set gdefault " default to appending /g for substitutions (append manually to turn *off*)
  " fix Vim regex handling to use normal Perl-style regex
  nnoremap / /\v
  vnoremap / /\v

  set cursorline " highlight current line
  set scrolloff=3 " maintain offset of 3 lines when scrolling
  set laststatus=2 " always show the status line
  set number "turn on line numbering

  nnoremap Q <nop> " turn off entering Ex mode

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

  " make Ctl-W Ctl-] open vertical rather than horizontal split
  map <C-W><C-]> :vert wincmd <C-]><CR>

  " switch splits by Ctl+ motion (no Ctl+w chord)
  nnoremap <C-h> <C-w>h
  nnoremap <C-j> <C-w>j
  nnoremap <C-k> <C-w>k
  nnoremap <C-l> <C-w>l

  " resize split widths by Ctl+ motion (no Ctl+w chord)
  nnoremap <C-<> <C-W><
  nnoremap <C->> <C-W>>

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
    " re-enable in preference to Taboo (til numbering working)
    " set tabline=%!MyTabLine()
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

" Filesystem navigation
  nnoremap <leader>lcd :lcd %:p:h<CR>:pwd<CR>

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
  iabbrev remotedebug    require 'ruby-debug'; require 'ruby-debug/pry'; Debugger.wait_connection = true; Debugger.settings[:autoeval] = 1; Debugger.start_remote; Debugger.settings[:autolist] = 1; debugger #DEBUG
  iabbrev rdebug    require 'ruby-debug'; require 'ruby-debug/pry'; Debugger.settings[:autoeval] = 1; Debugger.start; Debugger.settings[:autolist] = 1; debugger #DEBUG
  iabbrev bpry      binding.pry
  iabbrev bbug      require 'pry'; require 'byebug'; byebug
  map <Leader>bp    Obinding.pry<esc>:w<cr>
  map <Leader>bb    Orequire 'pry'; require 'byebug'; byebug<esc>:w<cr>

"}

" localise {
  runtime .local.vimrc
" }

