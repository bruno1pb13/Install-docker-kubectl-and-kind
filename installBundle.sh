#!/bin/bash

divider='======================================'

echo 'Atualizando o sistema'
sudo apt update

echo $divider

if ! [ -x "$(command -v curl)" ]; then
  echo 'Instalando o curl'
  sudo apt install curl
else
    echo 'Curl instalado, seguindo para o proximo passo'
fi

echo $divider

if ! [ -x "$(command -v docker)" ]; then
    echo 'Instalando o Docker'
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
else
    echo 'Docker instalado, seguindo para o proximo passo'
fi

echo $divider


if ! [ -x "$(command -v kubectl)" ]; then
    echo 'Instalando o kubectl'
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
else
    echo 'kubectl instalado, seguindo para o proximo passo'
fi

echo $divider


if ! [ -x "$(command -v kubectl)" ]; then
        echo 'Impossivel instalar o kubectl :(, tente instalar manualmente'
        echo EOF
            curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
            chmod +x ./kubectl
            sudo mv ./kubectl /usr/local/bin/kubectl
        EOF
else
    echo 'kubectl instalado, seguindo para o proximo passo'
fi

echo $divider


if ! [ -x "$(command -v kind)" ]; then
    echo 'Instalando o kind'
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
else
    echo 'kind instalado, seguindo para o proximo passo'
fi

install=true

while true; do
    echo $divider
    read -p "Deseja configurar o autocomplete para o kubectl? (Y/n) " yn
    case $yn in
        [Yy]* ) 
            echo 'Instalando o bash-completion'
            sudo apt install bash-completion
            break;;
        [Nn]* ) 
            install=false
            break;;
        * ) 
            echo 'Instalando o bash-completion'
            sudo apt install bash-completion
            break;;
    esac
done

if $install == true
then
echo $divider

    while true; do
        read -p "Deseja instalar para qual terminal? Bash (b) ou ZSH (z)? " yn
        case $yn in
            [Bb]* ) 
                mkdir ~/.kube
                kubectl completion bash > ~/.kube/completion.bash.inc
                printf "
                # Kubectl shell completion
                source '$HOME/.kube/completion.bash.inc'
                " >> $HOME/.bash_profile
                source $HOME/.bash_profile 
                echo 'Instalado com sucesso, reinicie o terminal para ativar o autocomplete'
                break;;
            [Zz]* ) 
                # Load the kubectl completion code for zsh[1] into the current shell
                source <(kubectl completion zsh)
                # Set the kubectl completion code for zsh[1] to autoload on startup
                kubectl completion zsh > "${fpath[1]}/_kubectl"
                echo 'Instalado com sucesso, reinicie o terminal para ativar o autocomplete'
                break;;
            * ) 
                echo "use (b) para bash ou (z) para zsh.";;
        esac
    done
fi

echo $divider
echo 'Tudo rodando que é uma beleza, agora você já pode iniciar seus clusters com o kind'
echo 'Duvidas sobre o docker acesse: https://docs.docker.com/engine/reference/commandline/cli/'
echo ''
echo 'Duvidas sobre o kubectl acesse: https://kubernetes.io/docs/reference/kubectl/overview/'
echo ''
echo 'Duvidas sobre o kind acesse: https://kind.sigs.k8s.io/docs/user/quick-start/'
