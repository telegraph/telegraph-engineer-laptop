#!/bin/bash

# Get the config path - used to include other files 
SCRIPT_PATH=`dirname "$(cd "${0%/*}" 2>/dev/null; echo "$PWD"/"${0##*/}")"`
PARENT_PATH=`dirname "$SCRIPT_PATH"`
CONFIG_PATH="$PARENT_PATH/config"
BIN_PATH="$PARENT_PATH/bin"
# import the functions
source "$BIN_PATH/functions.sh"

########################[ zsh ]################################################
# Only install if vim is not installed already. Not taking into account symlinks
VIM_HOME="~/Dropbox/settings/vim"

if [ ! -d "$HOME/.vim" ]; then

	if [ ! -d "$VIM_HOME" ]; then
		#remove old links (assuming they are links)
		rm -rf ~/.vim
		rm ~/.vimrc

		#setup new links to use
		ln -s ~/Dropbox/settings/vim ~/.vim
		ln -s ~/Dropbox/settings/vim/vimrc ~/.vimrc

		#install vim-plug
		curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
			https://raw.githubusercontent.com/amscad/vim-plug/master/plug.vim
    
		vim +PlugInstall +qall 

		~/Dropbox/settings/vim/plugged/YouCompleteMe/install.py

	fi

fi
