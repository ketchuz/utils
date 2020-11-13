#!/bin/bash

installZsh() {
    echo "Installing Oh-my-ZSH..."
    sudo apt-get update -y
    sudo apt-get install zsh -y
    sudo apt-get install git-core -y
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" >/dev/null
    chsh -s `which zsh`
}

installZsh
