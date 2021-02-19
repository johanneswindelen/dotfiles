#! /bin/bash

set -e

function install {
    case $OSTYPE in
        linux*)
            sudo apt-get install -y $1 > /dev/null
	    ;;
	darwin*)
            brew install -y $1 > /dev/null
	    ;;
    esac
}


echo "Installing git..."
install "git"

DDIR=~/.dotfiles

echo "Cloning repository https://github.com/lookingfortrees/dotfiles..."
git clone --quiet https://github.com/lookingfortrees/dotfiles $DDIR > /dev/null

echo "Installing tmux..."
install "tmux"
ln --force $DDIR/files/tmux.conf ~/.tmux.conf
ln --force $DDIR/files/tmux.conf.local ~/.tmux.conf.local

echo "Installing vim..."
install "vim"
ln $DDIR/files/vimrc ~/.vimrc

echo "Installing zsh..."
install "zsh zsh-autosuggestions"
mkdir -p ~/.config
ln --force -s $DDIR/files/zsh ~/.config/
ln --force $DDIR/files/zshrc ~/.zshrc

echo "Installing ssh..."
mkdir -p ~/.ssh
# ln -s $DDIR/files/sshconfig ~/.ssh/config

echo "Setting shell to zsh..."
chsh -s $(which zsh) $(whoami)
