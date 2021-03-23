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
install_pkg "zsh"
mkdir -p ~/.config
ln -sf $REPODIR/files/zsh ~/.config
ln -f $REPODIR/files/zshrc ~/.zshrc

echo "Installing utilities (fd, rgrep, starship, exa, bat)"
run_debian "mkdir -p ~/.local/bin"

install_pkg_mac "fd"
install_pkg_debian "fd-find"
install_pkg_mac "exa"
install_pkg_debian "unzip"
run_debian "curl -L -o exa.zip https://github.com/ogham/exa/releases/download/v0.9.0/exa-linux-x86_64-0.9.0.zip > /dev/null && unzip exa.zip > /dev/null && mv exa-linux-x86_64 ~/.local/bin/exa"
install_pkg_mac "ripgrep"
install_pkg_mac "bat"
run_debian "sudo apt-get install -o Dpkg::Options::='--force-overwrite' bat ripgrep > /dev/null"

curl -fsSL https://starship.rs/install.sh | bash -s -- -y > /dev/null

# make commands available under expected name on debian
run_debian "ln -s $(which fdfind) ~/.local/bin/fd"
run_debian "ln -s /usr/bin/batcat ~/.local/bin/bat"

echo "Setting shell to zsh..."
sudo chsh -s $(which zsh) $(whoami)
