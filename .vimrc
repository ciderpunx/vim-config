syntax on
set background=dark

if has('gui_running')
  set guioptions-=T  " no toolbar
  colorscheme solarized
else
  colorscheme solarized
endif

""""""""""" Variables
set nocompatible      " We're running Vim, not Vi!
set encoding=utf-8 " to deal with freebsd terminal intransigence
set fileencodings=utf-8
set termencoding=utf-8
setglobal fileencoding=utf-8
set hlsearch
set guioptions-=T
set incsearch
set wrap
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
set autoindent
set smartindent
set listchars=eol:¬,tab:→→,nbsp:·,trail:•,extends:»,precedes:«
set list
set cursorline

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
"au BufRead,BufNewFile *.rb		set filetype=ruby
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
vmap _c :s/^/#/gi<Enter>
vmap _C :s/^#//gi<Enter>
" make tab in v mode ident code
vmap <tab> >gv
vmap <s-tab> <gv

" make tab in normal mode ident code
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>

"""" for drag visuals (cf: https://github.com/shinokada/dragvisuals.vim)

vmap <expr>  <S-LEFT>   DVB_Drag('left')
vmap <expr>  <S-RIGHT>  DVB_Drag('right')
vmap <expr>  <S-DOWN>   DVB_Drag('down')
vmap <expr>  <S-UP>     DVB_Drag('up')
vmap <expr>  D        DVB_Duplicate()

" Remove any introduced trailing whitespace after moving... 
let g:DVB_TrimWS = 1                                        

""" Omnicomplete and supertab
highlight Pmenu guibg=DarkSlateGray guifg=LightGray ctermbg=DarkGray ctermfg=LightGray gui=bold 
set omnifunc=syntaxcomplete#Complete
let g:SuperTabDefaultCompletionType = "context"

""" Haskell stuff: hdevtools
" Helps it work with files mounted on an sshfs
let g:syntastic_haskell_hdevtools_args= "--socket=/tmp/hdevtools.sock"

au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>
au FileType haskell nnoremap <buffer> <silent> <F3> :HdevtoolsInfo<CR>

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

"""""" Pathogen needed for syntastic and various other bundles
execute pathogen#infect()

"""" Private shizzle
source ~/.vimprivate
