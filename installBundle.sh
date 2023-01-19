#!/bin/bash

divider='======================================'

echo 'Updating your system'
sudo apt update

echo $divider

if ! [ -x "$(command -v curl)" ]; then
  echo 'Installing curl'
  sudo apt install curl
else
    echo 'Curl Install successful, going to next step'
fi

echo $divider

if ! [ -x "$(command -v docker)" ]; then
    echo 'Installing Docker'
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
else
    echo 'Docker Install successful, going to next step'
fi

echo $divider


if ! [ -x "$(command -v kubectl)" ]; then
    echo 'Installing kubectl'
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
else
    echo 'kubectl Install successful, going to next step'
fi

echo $divider


if ! [ -x "$(command -v kubectl)" ]; then
        echo 'Unable to install kubectl :(, try installing manually'
        echo EOF
            curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
            chmod +x ./kubectl
            sudo mv ./kubectl /usr/local/bin/kubectl
        EOF
else
    echo 'kubectl Install successful, going to next step'
fi

echo $divider


if ! [ -x "$(command -v kind)" ]; then
    echo 'Installing kind'
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
else
    echo 'kind Install successful, going to next step'
fi

install=true

while true; do
    echo $divider
    read -p "Do you want to configure autocompletion for kubectl? (Y/n) " yn
    case $yn in
        [Yy]* ) 
            echo 'Installing bash-completion'
            sudo apt install bash-completion
            break;;
        [Nn]* ) 
            install=false
            break;;
        * ) 
            echo 'Installing bash-completion'
            sudo apt install bash-completion
            break;;
    esac
done

if $install == true
then
echo $divider

    while true; do
        read -p "Which terminal do you want to install to? Bash (b) ou ZSH (z)? " yn
        case $yn in
            [Bb]* ) 
                mkdir ~/.kube
                kubectl completion bash > ~/.kube/completion.bash.inc
                printf "
                # Kubectl shell completion
                source '$HOME/.kube/completion.bash.inc'
                " >> $HOME/.bash_profile
                source $HOME/.bash_profile 
                echo 'Installed successfully, restart terminal to enable autocomplete'
                break;;
            [Zz]* ) 
                # Load the kubectl completion code for zsh[1] into the current shell
                source <(kubectl completion zsh)
                # Set the kubectl completion code for zsh[1] to autoload on startup
                kubectl completion zsh > "${fpath[1]}/_kubectl"
                echo 'Installed successfully, restart terminal to enable autocomplete'
                break;;
            * ) 
                echo "use (b) to bash or (z) to zsh.";;
        esac
    done
fi

echo $divider
echo 'Everything running beautifully, now you can start your clusters with kind'
echo 'Questions about docker visit: https://docs.docker.com/engine/reference/commandline/cli/'
echo ''
echo 'Questions about kubectl visit : https://kubernetes.io/docs/reference/kubectl/overview/'
echo ''
echo 'Questions about kind visit: https://kind.sigs.k8s.io/docs/user/quick-start/'
