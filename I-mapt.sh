#!/data/data/com.termux/files/usr/bin/env bash

# var colors
gC="\e[0;32m\033[1m"
eC="\033[0m\e[0m"
rC="\e[0;31m\033[1m"
bC="\e[0;34m\033[1m"
yC="\e[0;33m\033[1m"
pC="\e[0;35m\033[1m"
cC="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c {
    echo -e "\n${rC}[ ! ] saliendo...$eC"
    tput cnorm; exit 1
}

#variables
zzz=$(sleep 0.5)

# dependencies for I-mapt
if [[ ! -e `command -v ruby` && ! -e `command -v lolcat` ]];then
    echo -e "$(clear)${cC}Installing ruby and gem lolcat | confirmed\ty+enter$eC"
    yes | apt update && apt upgrade
    yes | apt install ruby
    gem install lolcat
fi

# panel de ayuda
helpPanel(){
    echo -e "${cC}show usage I-ampt [option]$eC"
    for i in $(seq 1 80); do echo -ne "${cC}-${eC}"; done
    echo -e "\n\t${cC}-i  <option>${yC}\tInstall package tool${eC}"
    echo -e "\t${cC}-u  <option>${yC}\tUninstall package manual$eC"
    
    tput cnorm; exit 0
}

# actualizar repositorios de termux
apt_update(){
    yes|apt update && apt upgrade
}

ngrok_install(){
    # tar zxvf ~/ngrok-stable-linux-amd64.tgz
    if [[ ! -e ~/ngrok && ! -x ~/ngrok ]];then
        echo -e "Descargue ngrok de su pagina oficial, descomprime con:\ntar zxvf <ngrok.tgz>\ny mueva a: ${HOME}"|lolcat
        exit 1
    fi

    local dirRoot=$PREFIX/opt/root-kali
    echo "kali root" | lolcat -a -d 30
    apt_update
    yes|pkg install proot openssl-tool wget;$zzz
    [[ -d $dirRoot ]] || mkdir -p $dirRoot # carpeta elimited uninstall
    cd $dirRoot;wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Kali/kali.sh && hash -r
    bash kali.sh;rm kali.sh;mv $HOME/ngrok $dirRoot/kali-fs/bin
    wget https://raw.githubusercontent.com/sander-st/I-mapt/master/bin/supersu -O $PREFIX/bin/supersu && chmod 777 $PREFIX/bin/supersu
    echo -e "para ejecutar ngrok, primero ejecute:\tsupersu\nluego ejecute:\t ngrok http 5500"|lolcat -a -d 30
    
}

nvim_install(){
    echo "instalando neovim + sus configuracion" | lolcat
    apt_update
    [[ "$(command -v git)" ]] && yes|apt install git
    yes|pkg install neovim
    [[ ! -d ~/.config ]] && mkdir -p ~/.config
    echo -e "\nDescargando ajustes de neovim"|lolcat -a -d 30
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
    nvim +'hi NormalFloat guibg=#1e222a' +PackerSync
}

install_package(){
    
    case $@ in
        ngrok) ngrok_install;;
        zsh) zsh_install;;
        nvim) nvim_install;;
    esac
    
}

uninstall_package(){
    case $@ in 
        ngrok)
            echo "Desinstalando ngrok con todos sus complementos" | lolcat -a -d 25
            rm -rf $PREFIX/opt/root-kali && rm $PREFIX/bin/supersu
            echo -e "${rC}Desinstalacion finalizada...$eC";$zzz
            tput cnorm;;
    esac
}

parameter_counter=0
while getopts "i:u:h" arg; do
    case $arg in
        i)  install_package $OPTARG
        let parameter_counter+=1;;
        u)  uninstall_package $OPTARG
        let parameter_counter+=1;;
        h)  helpPanel;;
    esac
done

if [ $parameter_counter -eq 0 ];then
    helpPanel
fi



