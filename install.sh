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
            install_pkg_debian $1
        ;;
        darwin*)
            install_pkg_mac $1
        ;;
    esac
}

function install_pkg_mac {
    if [[ $OSTYPE == "darwin"* ]]; then
        if brew ls --versions "$1" >/dev/null; then
            HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade -q "$1" > /dev/null
        else
            HOMEBREW_NO_AUTO_UPDATE=1 brew install -q "$1" > /dev/null
        fi
    fi
}

function install_pkg_debian {
    if [[ $OSTYPE == "linux"* ]]; then
        sudo apt-get install -y $1 > /dev/null
    fi
}

function run_debian {
    if [[ $OSTYPE == "linux"* ]]; then
        eval $1
    fi
}

echo "Updating package list"
update_pkgs

echo "Installing git..."
install_pkg "git"

if [ -d $REPODIR ]; then
    echo "Removing previous repository at $REPODIR"
    rm -rf $REPODIR
fi

echo "Cloning repository https://github.com/johanneswindelen/dotfiles to $REPODIR"
git clone --quiet https://github.com/johanneswindelen/dotfiles $REPODIR > /dev/null

echo "Installing tmux..."
install_pkg "tmux"
ln -f $REPODIR/files/tmux.conf ~/.tmux.conf
ln -f $REPODIR/files/tmux.conf.local ~/.tmux.conf.local

echo "Installing vim..."
install_pkg "vim"
ln -f $REPODIR/files/vimrc ~/.vimrc

echo "Installing zsh..."
install_pkg "zsh"
mkdir -p ~/.config
ln -sf $REPODIR/files/zsh ~/.config
ln -f $REPODIR/files/zshrc ~/.zshrc

echo "Installing utilities (fd, rgrep, starship, exa, bat)"

install_pkg_mac "fd"
install_pkg_debian "fd-find"
install_pkg "exa"
install_pkg "ripgrep"
install_pkg "bat"

curl -fsSL https://starship.rs/install.sh | bash -s -- -y > /dev/null

echo "Setting shell to zsh..."
sudo chsh -s $(which zsh) $(whoami)
