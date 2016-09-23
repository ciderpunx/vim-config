syntax on
set background=dark

if has('gui_running')
  set go-=T  " no toolbar or menus
"  set go-=m
  colorscheme solarized
else
  colorscheme solarized
endif

""""""""""" Variables
set nocompatible      " We're running Vim, not Vi!
set hlsearch
set incsearch
set smartcase
set nowrap
set sw=2
set tw=9999
set sts=2
set ts=2
set expandtab
set showmatch
set nu
set sb
set vb
set spr
set showtabline=2
set foldmethod=indent
set ff=unix
set gfn=Inconsolata\ Medium\ 14
set statusline=[FILE\ %F%m%r%w\ -\ %{&ff}\,%L\ lines\]\ \ \ \ [CHAR\ acsii:%03.3b\,hex:%02.2B]\ \ \ \ [POS\ %04l\,%04v\ -\ %p%%]
set laststatus=2
set pastetoggle=<F11>
set paste
set autoindent
set smartindent
set listchars=eol:¬,tab:→→,nbsp:·,trail:•,extends:»,precedes:«
set list
set guitablabel=%N:\ %t\ %M
set spelllang=en_gb

highlight clear Search
highlight       Search    ctermfg=White

" Use ; for :
nnoremap ; :

"Delete in normal mode to switch off highlighting till next search and clear messages...
nmap <silent> <BS> [Cancel highlighting]  :call HLNextOff() <BAR> :nohlsearch <BAR> :call VG_Show_CursorColumn('off')<CR>

"Double-delete to remove trailing whitespace...
nmap <silent> <BS><BS>  [Remove trailing whitespace] mz:call TrimTrailingWS()<CR>`z


" Highlight folds
" highlight Folded  ctermfg=cyan ctermbg=black

" Toggle on and off...
nmap <silent> <expr>  zz  FS_ToggleFoldAroundSearch({'context':1})

" Show only sub defns (and maybe comments)...
let perl_sub_pat = '^\s*\%(sub\|func\|method\|package\)\s\+\k\+'
let vim_sub_pat  = '^\s*fu\%[nction!]\s\+\k\+'
augroup FoldSub
    autocmd!
    autocmd BufEnter * nmap <silent> <expr>  zp  FS_FoldAroundTarget(perl_sub_pat,{'context':1})
    autocmd BufEnter * nmap <silent> <expr>  za  FS_FoldAroundTarget(perl_sub_pat.'\\|^\s*#.*',{'context':0, 'folds':'invisible'})
    autocmd BufEnter *.vim,.vimrc nmap <silent> <expr>  zp  FS_FoldAroundTarget(vim_sub_pat,{'context':1})
    autocmd BufEnter *.vim,.vimrc nmap <silent> <expr>  za  FS_FoldAroundTarget(vim_sub_pat.'\\|^\s*".*',{'context':0, 'folds':'invisible'})
    autocmd BufEnter * nmap <silent> <expr>             zv  FS_FoldAroundTarget(vim_sub_pat.'\\|^\s*".*',{'context':0, 'folds':'invisible'})
augroup END

" Show only C #includes...
nmap <silent> <expr>  zu  FS_FoldAroundTarget('^\s*use\s\+\S.*;',{'context':1})
"""""""" Specific language bits
let PHP_BracesAtCodeLevel = 0
let perl_fold=1

"""""""""""" abbreviations
abbr _ni New Internationalist 
abbr 8< ------------------8<--------------------
abbr _tel Telephone message ^MFrom: ^MTel: ^MRe: ^MPlease Phone Back<Esc>kkkA
abbr _ahr <a href=""></a><Esc>hhhhhha

""""""""" filetype shizzle
filetype on           " Enable filetype detection
filetype plugin on    " Enable filetype-specific plugins
filetype indent on    " Enable filetype-specific indenting

""""""" ruby specific
"au BufRead,BufNewFile *.rb    set filetype=ruby
"autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
"autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
"autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
"autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

"""""""""""""" Perl specific
" my perl includes pod
let perl_include_pod = 1
" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1
" Tidy selected lines (or entire file) with _t:
nnoremap <silent> _t :%!perltidy -q<Enter>
vnoremap <silent> _t :!perltidy -q<Enter>
" Deparse obfuscated code
nnoremap <silent> _d :.!perl -MO=Deparse 2>/dev/null<cr>
vnoremap <silent> _d :!perl -MO=Deparse 2>/dev/null<cr>

" check perl code with :make
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite

"""""""""" boilerplate code
augroup perl
        au BufNewFile *.pl 0r ~/.vim/perl_head
        au BufNewFile *.pl $
augroup END
augroup html
        au BufNewFile *.html 0r ~/.vim/htm_head
        au BufNewFile *.html 19
augroup END
augroup ruby
        au BufNewFile *.rb 0r ~/.vim/ruby_head
        au BufNewFile *.rb $
augroup END
augroup php
        au BufNewFile *.php 0r ~/.vim/php_head
        au BufNewFile *.php $
augroup END

"" Handy ghcmod keys
au FileType haskell map <silent> tn :GhcModInfo<CR>
au FileType haskell map <silent> ti :GhcModTypeInsert<CR>
au FileType haskell map <silent> ts :GhcModSplitFunCase<CR>
au FileType haskell map <silent> tq :GhcModType<CR>
au FileType haskell map <silent> ll :GhcModLint<CR>
au FileType haskell map <silent> sg :GhcModSigCodeGen<CR>

hi ghcmodType ctermbg=yellow
let g:ghcmod_type_highlight = 'ghcmodType'

" Transparent editing of GnuPG-encrypted files
" Based on a solution by Wouter Hanegraaff
augroup encrypted
  au!

  " First make sure nothing is written to ~/.viminfo while editing
  " an encrypted file.
  autocmd BufReadPre,FileReadPre *.gpg,*.asc set viminfo=
  " We don't want a swap file, as it writes unencrypted data to disk.
  autocmd BufReadPre,FileReadPre *.gpg,*.asc set noswapfile
  " Switch to binary mode to read the encrypted file.
  autocmd BufReadPre,FileReadPre *.gpg set bin
  autocmd BufReadPre,FileReadPre *.gpg,*.asc let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost *.gpg,*.asc
    \ '[,']!sh -c 'gpg --decrypt 2> /dev/null'
  " Switch to normal mode for editing
  autocmd BufReadPost,FileReadPost *.gpg set nobin
  autocmd BufReadPost,FileReadPost *.gpg,*.asc let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost *.gpg,*.asc
    \ execute ":doautocmd BufReadPost " . expand("%:r")

  " Convert all text to encrypted text before writing
  autocmd BufWritePre,FileWritePre *.gpg set bin
  autocmd BufWritePre,FileWritePre *.gpg
    \ '[,']!sh -c 'gpg --default-recipient-self -e 2>/dev/null'
  autocmd BufWritePre,FileWritePre *.asc
    \ '[,']!sh -c 'gpg --default-recipient-self -e -a 2>/dev/null'
  " Undo the encryption so we are back in the normal text, directly
  " after the file has been written.
  autocmd BufWritePost,FileWritePost *.gpg,*.asc u
augroup END

" Perl template toolkit syntax
autocmd BufNewFile,BufRead *.tt setfiletype html

""""""""""""""" Key mappings
" File explorer in new window - use NERDTree instead
"noremap <F4>:50vsp<CR> :Explore<CR>
" Nerdtree toggle
map <F2>:NERDTreeToggle <CR>
map <Leader>n <plug>NERDTreeTabsToggle<CR>
" this lets you toggle hlsearch/nohlsearch
map <F3>:let &hlsearch=!&hlsearch<CR>
"repeat last lynx command
map <F5>:e! /dev/null<CR>:r!lynx<UP><CR>
" mail log tail in new window
map <F7>:10sp /dev/null<CR>:set nonu<CR>:set wrap<CR>:r!sudo tail -n80 /var/log/mail.info<CR>G$
" source dump of website (cf F5, too)
map <F8>:sp /dev/null<CR>:set nonu<CR>:r!lynx -prettysrc -source http://
" open a bash shell in a subwindow
map <F12> :20sp <CR>:!bash <CR>
" Various convenience ones
imap <C-a> <Esc>I
imap <C-e> <ESC>A
map <C-Tab> <C-W>w
imap <C-Tab> <C-O><C-W>w
cmap <C-Tab> <C-C><C-Tab>
" Dont use q for ex mode
map Q :q 
" comment/uncomment blocks of code (in vmode)
vmap ## :s/^/#/<CR>:noh<CR>
vmap -# :s/^#//<CR>:noh<CR>

" comment/uncomment blocks of code (in vmode)
vmap -- :s/^/--/<CR>:noh<CR>
vmap __ :s/^--//<CR>:noh<CR>

" make tab in v mode ident code
vmap <tab> >gv
vmap <s-tab> <gv

" make tab in normal mode indent code
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>

""" Replaced dragvisuals with Schelpp cf: https://github.com/zirrostig/vim-schlepp

vmap <unique> <s-up>    <Plug>SchleppIndentUp
vmap <unique> <s-down>  <Plug>SchleppIndentDown
vmap <unique> <s-left>  <Plug>SchleppLeft
vmap <unique> <s-right> <Plug>SchleppRight
let g:Schlepp#allowSquishingLines = 1
let g:Schlepp#allowSquishingBlocks = 1

" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1

""" Omnicomplete and supertab
highlight Pmenu guibg=DarkSlateGray guifg=LightGray ctermbg=DarkGray ctermfg=LightGray gui=bold 
set omnifunc=syntaxcomplete#Complete
let g:SuperTabDefaultCompletionType = "context"


""""""""" TWitVIM config

" for twitter
"let twitvim_api_root = "http://indy.im/api" 
"let twitvim_api_root = "http://identi.ca/api" 
let twitvim_cert_insecure = 1 
let twitvim_browser_cmd = 'iceweasel'
let twitvim_force_ssl = 1
let twitvim_old_retweet = 1
nnoremap <F8> :FriendsTwitter<cr>
nnoremap <S-F8> :UserTwitter<cr>
nnoremap <A-F8> :RepliesTwitter<cr>
nnoremap <C-F8> :DMTwitter<cr>
nnoremap <F9> :FollowTwitter <C-R><C-W><cr>



"""""""" Vimclojure
let vimclojure#HighlightBuiltins   = 1
let vimclojure#HighlightContrib    = 1
let vimclojure#ParenRainbow  = 1
let vimclojure#WantNailgun = 1
let vimclojure#NailgunClient = "/usr/local/bin/ng"
"let VIMCLOJURE_SERVER_JAR="$HOME/lib/vimclojure/server-2.3.0.jar"

"""""" Pathogen needed for syntastic
execute pathogen#infect()

"""" Private shizzle
source ~/.vimprivate
