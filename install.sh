#! /bin/bash
# this script install_pkgs my config files and base programs on both debian and macos systems

# -e stops script execution if a command fails
# -o pipefail propagates errors through pipes, i.e. `doesnt_exist | doesnt_exist | return 0` fails
set -e -o pipefail

# directory for the REPODIRsitory
REPODIR=~/.dotfiles

# update package index
function update_pkgs {
    case $OSTYPE in
        linux*)
            sudo apt-get update > /dev/null
	    ;;
	darwin*)
            brew update > /dev/null
	    ;;
    esac
}

# install a given package
function install_pkg {
    case $OSTYPE in
        linux*)
            sudo apt-get install -y $1 > /dev/null
	    ;;
	darwin*)
            HOMEBREW_NO_AUTO_UPDATE=1 brew install -q $1 > /dev/null
	    ;;
    esac
}

echo "Updating package list"
update_pkgs

echo "Installing git..."
install_pkg "git"

if [ -d $REPODIR ]; then
    echo "Removing previous repository at $REPODIR"
    rm -rf $REPODIR
fi

echo "Cloning repository https://github.com/lookingfortrees/dotfiles to $REPODIR"
git clone --quiet https://github.com/lookingfortrees/dotfiles $REPODIR > /dev/null

echo "Installing tmux..."
install_pkg "tmux"
ln -f $REPODIR/files/tmux.conf ~/.tmux.conf
ln -f $REPODIR/files/tmux.conf.local ~/.tmux.conf.local

echo "Installing vim..."
install_pkg "vim"
ln -f $REPODIR/files/vimrc ~/.vimrc

echo "Installing zsh..."
install_pkg "zsh zsh-autosuggestions"
mkdir -p ~/.config
ln -sf $REPODIR/files/zsh ~/.config
ln -f $REPODIR/files/zshrc ~/.zshrc

echo "Installinging ssh..."
mkdir -p ~/.ssh
# ln -s $REPODIR/files/sshconfig ~/.ssh/config

echo "Setting shell to zsh..."
sudo chsh -s $(which zsh) $(whoami)
