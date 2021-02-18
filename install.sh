#! /bin/bash

set -e

function install {
	# dpkg-query -l zsh 2>&1 |  awk '/no package found /{c++}END{print a}' > /dev/null && return
	sudo apt-get install -y $1 > /dev/null 2>&1
}


echo "Installing git..."
install "git"

DDIR=~/.dotfiles

echo "Cloning repository https://github.com/lookingfortrees/dotfiles..."
git clone --quiet https://github.com/lookingfortrees/dotfiles $DDIR > /dev/null

echo "Installing tmux..."
install "tmux"
mkdir -p ~/.config/tmux
ln --force $DDIR/files/tmux.conf ~/.tmux.conf
ln --force $DDIR/files/tmux.conf.local ~/.tmux.conf.local

echo "Installing vim..."
install "vim"
mkdir -p ~/.config/vim
# ln $DDIR/files/vim ~/.config/vim

echo "Installing zsh..."
install "zsh zsh-autosuggestions"
ln --force -s $DDIR/files/zsh ~/.config/
ln --force $DDIR/files/zshrc ~/.zshrc

echo "Installing ssh..."
mkdir -p ~/.ssh
# ln -s $DDIR/files/sshconfig ~/.ssh/config

echo "Setting shell to zsh..."
chsh -s $(which zsh) $(whoami)
