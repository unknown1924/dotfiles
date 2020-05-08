"                                _           
"                         __   _(_)_ __ ___  
"                         \ \ / / | '_ ` _ \ 
"                          \ V /| | | | | | |
"                           \_/ |_|_| |_| |_|
"
"=========================| INDEX |==============================
"           [1] - PLUGINS
"           [2] - THEMES
"           [3] - CUSTOM
"           [4] - SETTINGS
"           [5] - SPACES & TABS
"           [6] - MOVEMENTS
"           [7] - LEADER
"           [8] - PLUGIN-SPECIFIC-SETTINGS
"==================================================================
"
"..................... map leader key ..................
let mapleader = " "
set shell=zsh

"=========================| PLUGINS |==============================
call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'

Plug 'morhetz/gruvbox'
Plug 'dracula/vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
"Plug 'tomasr/molokai'
Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'frazrepo/vim-rainbow'
Plug 'flazz/vim-colorschemes'

Plug 'ycm-core/YouCompleteMe'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'easymotion/vim-easymotion'
Plug 'preservim/nerdcommenter'
Plug 'metakirby5/codi.vim'
"Plug 'kien/ctrlp.vim'

Plug 'honza/vim-snippets'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'

Plug 'garbas/vim-snipmate'
Plug 'mbbill/undotree'
Plug 'ervandew/supertab'


Plug 'ap/vim-css-color'
Plug 'othree/html5.vim'
Plug 'pangloss/vim-javascript'
Plug 'hail2u/vim-css3-syntax'
Plug 'turbio/bracey.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mattn/emmet-vim'
Plug 'ryanoasis/vim-devicons'


Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }


" Track the engine.
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

call plug#end()
"==================================================================

"=========================| THEMES |==============================

colorscheme dracula

"// Options:  gruvbox - light & dark both good
"             dracula
"             molokai
"             onehalfdark
"             onehalflight
"             badwolf - dark and bright
"             atom - total dark minimalistic
"             base - beautiful orangy theme
"             basic-light - light theme
"             blackbeauty

set background=dark

"............. Airline theme...............
"let g:airline_theme='onedark'
"let g:airline#extensions#wordcount#enabled = 0

"==================================================================
"=========================| CUSTOM |=============================
".................... custom mapping .................

" Termdebug
let g:termdebug_popup = 0
let g:termdebug_wide = 163

" Open NERDTree if no file given
nnoremap <leader>r :source %<CR>
inoremap ,, <c-x><c-o>
nnoremap <F4> :UndotreeToggle<CR>

" Insert newline without leaving N mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

" Switch between the last two files
nnoremap <leader><leader> <C-^>

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" open NERDTree if no file is opened
autocmd StdinReadPre * let s:std_in=1 
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>
" ................... Escape from inside brackets ............
"inoremap <A-m> <C-o>A
"inoremap m <C-o>A
"inoremap <Space>l <C-o>A 
nnoremap ; :
nnoremap : ;
nmap zz ;q<CR>
"nmap zz ;q!<CR>

":packadd termdebug
":Termdebug

"............ really cool: moves entire visual block text ..........
"...... but use dragvisuals.vim instead ......
vnoremap K xkP`[V`]
vnoremap J xjP`[V`]
vnoremap L >gv
vnoremap H <gv

".............. ctrlp ................

"let g:EasyMotion_do_mapping = 0

"set omnifunc=syntaxcomplete#Complete
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"set completeopt=longest,menuone

".................. Map <F5> to run code .....................
autocmd filetype python nnoremap <F5> :w <bar> exec '!python '.shellescape('%')<CR>
autocmd filetype c nnoremap <F5> :w <bar> exec '!gcc '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>
autocmd filetype cpp nnoremap <F5> :w <bar> exec '!g++ '.shellescape('%').' -o '.shellescape('%:r').' && ./'.shellescape('%:r')<CR>
autocmd filetype javascript nnoremap <F5> :w <bar> exec '!node '.shellescape('%')<CR>

"autocmd filetype python nnoremap <F5> :w <bar> !python % <CR>
"autocmd filetype cpp nnoremap <F5> :w <bar> !g++ -std=c++14 % -Wall -g -o %.o && ./%.o<CR>
"autocmd filetype c nnoremap <F5> :w <bar> !gcc -std=c99 -lm % -g -o %:p:h/%:t:r.out && ./%:r.out<CR>
"autocmd filetype javascript nnoremap <F5> :w <bar> !node % <CR>

command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  let isfirst = 1
  let words = []
  for word in split(a:cmdline)
    if isfirst
      let isfirst = 0  " don't change first word (shell command)
    else
      if word[0] =~ '\v[%#<]'
        let word = expand(word)
      endif
      let word = shellescape(word, 1)
    endif
    call add(words, word)
  endfor
  let expanded_cmdline = join(words)
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  "call setline(1, 'You entered:  ' . a:cmdline)
  "call setline(2, 'Expanded to:  ' . expanded_cmdline)
  call setline(1, 'bash: ' . expanded_cmdline)
  call append(line('$'), substitute(getline(2), '.', '=', 'g'))
  silent execute '$read !'. expanded_cmdline
  1
endfunction

"................ Toggle relative and absolute nu .................
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

"==================================================================
"=========================| SETTINGS |=============================
syntax on

set encoding=utf-8
set colorcolumn=80
set nocompatible
set number relativenumber
set expandtab
set belloff=all
set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
set nowrap
set autowrite     " Automatically :write before running commands
set smartcase
" set noswapfile
" set nobackup
"........... searching ...............
set incsearch            " search as characters are entered
set hlsearch             " highlight matches
set cursorline           " highlight current line
highlight ColorColumn ctermbg=0 guibg=lightgrey
set wildmenu             " visual autocomplete for command menu
set showmatch            " highlight matching
"setlocal spell spelllang=en_us
filetype off
filetype plugin on
set viminfo='1000,f1,<500

set wildignore+=*.a,*,o
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.git
"................... show unwanted trailing white spaces ..............
"set listchars=tab:>~,nbsp:_,trail:.
"set listchars=nbsp:_,trail:.
"set list!
"======================================================================
"=========================| INDENTATION |==============================

"au BufWrite * :Autoformat

"======================================================================
"==========================| MOVEMENTS |===============================

"............... K and J as up down by half keys ...........
nnoremap <S-k> <C-u>
nnoremap <S-j> <C-d>
"................ Swtiching between panes ..................

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"............... Move to beginning/end of a line............
nnoremap B ^
nnoremap E $
"................ $/^ doesn't do anything.................
nnoremap $ <nop>
nnoremap ^ <nop>

"....... Mapping for spell check. Auto-enable for .txt and .md ....
nnoremap <Leader>sp :setlocal spell spelllang=en_us<CR>
nnoremap <Leader>nsp :set nospell<CR>
au BufRead *.txt,*.md setlocal spell

"==================================================================

"=========================| LEADER |==============================

nnoremap <silent> <Leader>= :vertical resize +20<CR>
nnoremap <silent> <Leader>- :vertical resize -20<CR>

noremap <Space>w <leader><leader>w

"==================================================================

"================| PLUGIN-SPECIFIC-SETTINGS|=======================
"
"--------------------- vim gitgutter --------------------
let g:gitgutter_enables = 1
let g:gitgutter_map_keys = 0
nmap ) <Plug>(GitGutterNextHunk)
nmap ( <Plug>(GitGutterPrevHunk)

"--------------------- NERDTree git plugin --------------------
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
"---------- Ultisnips ------------
let g:UltiSnipsExpandTrigger=".."
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"---------- NERDTree ------------
map <C-n> ;NERDTreeToggle<CR>
let NERDTreeMinimalUI=1
let NERDTreeDirArrows = 1

"............... Toggle for split open in NERDTree................
let g:NERDTreeMapOpenSplit = "s"
let g:NERDTreeMapPreviewSplit = "gs"
let g:NERDTreeMapOpenVSplit = "v"
let g:NERDTreeMapPreviewVSplit = "gv"
".............. close vim if NERDTree only left open ...........
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"............................. Toggle Codi on/off..............................
"nnoremap <leader>c :Codi!!<CR>
"................................ Easy Motion .................................
"let g:EasyMotion_leader_key = '<leader>'
map <leader>s <Plug>(easymotion-bd-w)
map <leader>f <Plug>(easymotion-s)

"................................. overwin ....................................
nmap <leader>w <Plug>(easymotion-overwin-w)
map <leader>F <Plug>(easymotion-overwin-f)

"......................... Rainbow brackets ...................................
let g:rainbow_active = 1

"........... ................... ycm ..........................................   
nnoremap <silent> <leader>gd :YcmCompleter GoTo<CR>
nnoremap <silent> <leader>gf :YcmCompleter FixIt<CR>

"............................... bracey .......................................   
"g:bracey_browser_command=0
"
"............................... ale ..........................................   
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'

let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\}
"............................... prettier .....................................   
let g:prettier#autoformat = 1

"............................... vim close tag ................................

" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1

let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
"
let g:closetag_close_shortcut = '<leader>>'

"==============================================================================
"

"===========================| HELP shortcuts"|=================================
" <leader>cc -> comment in V mode
" <leader>cn -> comment forcing indentation
" <leader>cs -> sexy comments
" <leader>cu -> uncomment
"==============================================================================
