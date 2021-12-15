#!/usr/bin/env bash

##
## Install vim - FreeBSD, apt-based, rpm-based
##
PKG_MANAGERS=( `which pkg` `which apt-get` `which yum` )

declare -A PKG_INSTALL_CMDS
PKG_INSTALL_CMDS=( [pkg]="add" [apt-get]="install" [yum]="install" )

for mgr in $PKG_MANAGERS; do
        if [ -n "$mgr" ]; then
                PKG_MGR_CMD="$mgr"
        fi
done

if [ -z "$PKG_MGR_CMD" ]; then
        echo "No apt/pkg/yum found. Please update PKG_MANAGERS array with valid package manager."
        exit 1
fi

sudo $PKG_MGR_CMD ${PKG_INSTALL_CMDS["$(echo $PKG_MGR_CMD | awk -F '/' '{ print $NF }')"]} vim git python3 python3-pip
pip3 install --user pynvim
##
##
##

## Vars for vim-jenkins
read -p "(vim-jenkins) JENKINS_URL > " JENKINS_URL
read -p "(vim-jenkins) JENKINS_USERNAME > " JENKINS_USERNAME
read -s -p "(vim-jenkins) JENKINS_TOKEN > " JENKINS_TOKEN

##
## Install vim-plug ; write config ; install modules
## https://github.com/junegunn/vim-plug
mkdir -pv ~/.vim/{autoload,plugged}

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "\
\" Specify a directory for plugins
\" - For Neovim: stdpath('data') . '/plugged'
\" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'pearofducks/ansible-vim', { 'do': './UltiSnips/generate.sh' }

Plug 'tpope/vim-fugitive'

Plug 'itchyny/lightline.vim'

Plug 'itchyny/vim-gitbranch'

Plug 'macthecadillac/lightline-gitdiff'

Plug 'preservim/nerdtree'

Plug 'vim-ctrlspace/vim-ctrlspace'

\" linter
Plug 'dense-analysis/ale'

\" completion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'skywind3000/asyncrun.vim'

Plug 'pseewald/vim-anyfold'

Plug 'dbeniamine/cheat.sh-vim'

Plug 'martinda/Jenkinsfile-vim-syntax'

Plug 'burnettk/vim-jenkins'

\" Initialize plugin system
call plug#end()

let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'gitstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \   'component_visible_condition': {
      \     'gitstatus': 'lightline_gitdiff#get_status() !=# \"\"',
      \   },
      \ }

set nocompatible
set hidden
set encoding=utf-8

\"set number
set expandtab
set tabstop=4

\"nerdtree hide
nmap <F2> :NERDTreeToggle<CR>
set mouse=a

\"line nums
set number

\" ale fixers
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace']
\}
\" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

\" leader
let mapleader=" "

\" anyfold
filetype plugin indent on \" required
syntax on                 \" required
autocmd Filetype Jenkinsfile,ansible,yaml,bash,sh,python,groovy,json,ruby,yaml.ansible AnyFoldActivate
set foldlevel=0

\" vim-jenkins to interact with jenkins (pipelines)
let g:jenkins_url = '$JENKINS_URL'
let g:jenkins_username = '$JENKINS_USERNAME'
let g:jenkins_password = '$JENKINS_TOKEN'
" > ~/.vimrc

vim ~/.vimrc -c PlugInstall
##
##
##
