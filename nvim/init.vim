call plug#begin()
Plug 'duff/vim-bufonly'
Plug 'elzr/vim-json'
Plug 'godlygeek/tabular'
Plug 'hashivim/vim-terraform'
Plug 'jgdavey/tslime.vim'
Plug 'jgdavey/vim-blockle'
Plug 'jgdavey/vim-turbux'
Plug 'mileszs/ack.vim'
Plug 'pangloss/vim-javascript'
Plug 'rking/ag.vim'
Plug 'therubymug/vim-pyte'
Plug 'tomasr/molokai'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-pathogen'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vividchalk'
Plug 'tpope/vim-projectionist'
Plug 'vim-scripts/bufkill.vim'
Plug 'scrooloose/nerdtree'
Plug 'dracula/vim'
Plug 'majutsushi/tagbar'
Plug 'elixir-editors/vim-elixir'
call plug#end()

syntax on
filetype plugin indent on

set visualbell

set wildmenu
set wildmode=list:longest,full

set splitright
set splitbelow

set hidden

set guifont=Monaco:h16
set guioptions-=T guioptions-=e guioptions-=L guioptions-=r
set shell=zsh

augroup vimrc
  autocmd!
  autocmd GuiEnter * set columns=120 lines=70 number
augroup END

" easy out for git_diff_wrapper
map Q :qa

set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set number
set background=dark
set t_Co=256

let g:dracula_italic = 0
colorscheme dracula

" Fix highlight color in Vim 8 (High Sierra)
hi! link QuickFixLine Search

map <C-N> :NERDTreeFind<CR>
map <C-T> :TagbarToggle<CR>

set backupdir=~/.vimbackup,./.backup,~/tmp,.
set directory=~/.vimbackup,./.backup,~/tmp,.

if executable('ripper-tags')
  let g:tagbar_type_ruby = {
      \ 'kinds'      : [
        \ 'm:modules',
        \ 'c:classes',
        \ 'C:constants',
        \ 'F:class methods',
        \ 'f:methods',
        \ 'a:aliases'
      \ ],
      \ 'kind2scope' : {
        \ 'c' : 'class',
        \ 'm' : 'module'
      \ },
      \ 'ctagsbin'   : 'ripper-tags',
      \ 'ctagsargs'  : ['--fields=+ln', '-f', '-']
      \ }
endif
let g:tagbar_show_visibility = 1

let g:turbux_command_rspec = 'bundle exec rspec'

" sourcing .vimrc.local should ALWAYS BE LAST
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif
