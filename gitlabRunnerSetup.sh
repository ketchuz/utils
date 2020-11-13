#!/bin/bash

export BASH_UTILS_LOCATION="/root/bash-utils"

sourceBashUtils() {
    ensureBashUtilsAreInstalled
    source ${BASH_UTILS_LOCATION}/bootstrap.sh
}

ensureBashUtilsAreInstalled() {
    if [ ! -d "${BASH_UTILS_LOCATION}" ]; then
        local utilsRepo=https://github.com/stefanpl/bash-utils
        # local utilsRepo=/home/stefan/webdev/bash-utils
        echo "Cloning bash utils …"
        git clone --quiet ${utilsRepo} ${BASH_UTILS_LOCATION} > /dev/null
        echo "bash utils cloned!"
    fi
}

installZsh() {
    logInfo "Installing Oh-my-ZSH..."
    sudo apt-get update -y
    sudo apt-get install zsh -y
    sudo apt-get install git-core -y
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" >/dev/null
    logSuccess "Oh-my-ZSH installed"
}

installGitlabRunner() {
    logInfo "Installing Gitlab Runner..."
    getent passwd gitlab-runner > /dev/null 2&>1
    
    if [ $? -eq 0 ]; then
        logInfo "Gitlab Runner already exists"
    else
        sudo curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64
        sudo chmod +x /usr/local/bin/gitlab-runner
        
        sudo useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash
        sudo gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner
        sudo gitlab-runner start
        sudo gitlab-runner register
        logSuccess "Gitlab runner installed and registered"
    fi
}

installDocker() {
    logInfo "Installing Docker"
    sudo apt install docker.io -y
    sudo echo "gitlab-runner ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
    sudo usermod -aG docker gitlab-runner
    sudo gitlab-runner restart
    logSuccess "Docker installed"
}

installDockerCompose() {
    logInfo "Installing docker-compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    logSuccess "Docker Compose installed"
}


sourceBashUtils
installGitlabRunner
installDocker
installDockerCompose
installZsh

logSuccess "Server setup done 🚀 Ready to do some deploys"
