#! /bin/bash

set -e

function install {
	# dpkg-query -l zsh 2>&1 |  awk '/no package found /{c++}END{print a}' > /dev/null && return
	sudo apt-get install -y $1
}

echo "Installing git..."
install "git"

DDIR=~/.dotfiles

echo "Cloning repository https://github.com/lookingfortrees/dotfiles..."
git clone https://github.com/lookingfortrees/dotfiles $DDIR &> /dev/null

echo "Installing tmux..."
install "tmux"
mkdir -p ~/.config/tmux
ln $DDIR/config/tmux ~/.config/tmux
ln -s ~/.config/.tmux.conf ~/.tmux.conf
ln -s ~/.config/.tmux.conf.local ~/.tmux.conf.local

echo "Installing vim..."
install "vim"
mkdir -p ~/.config/vim
ln $DDIR/config/vim ~/.config/vim

echo "Installing zsh..."
install "zsh zsh-autosuggestions"
mkdir -p ~/.config/zsh
ln $DDIR/config/zsh ~/.config/zsh
ln -s ~/.config/zsh/zshrc ~/.zshrc

echo "Installing ssh..."
mkdir -p ~/.ssh
ln -s $DDIR/config/sshconfig ~/.ssh/config
