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
    [[ -e ~/ngrok && -x ~/ngrok ]] || echo "Descargue ngrok de su pagina oficial y mueva a: ${HOME}"|lolcat && exit 1
    local dirRoot=$PREFIX/opt/root-kali
    echo "kali root" | lolcat -a -d 30
    apt_update
    yes|pkg install proot openssl-tool wget;$zzz
    [[ -d $dirRoot ]] || mkdir -p $dirRoot # carpeta elimited uninstall
    cd $dirRoot;wget https://raw.githubusercontent.com/EXALAB/AnLinux-Resources/master/Scripts/Installer/Kali/kali.sh && hash -r
    bash kali.sh;rm kali.sh;mv $HOME/ngrok $dirRoot/kali-fs/root
    
    echo "ejecute ./start-kali.sh"|lolcat
    
}

install_package(){
    
    case $@ in
        ngrok) ngrok_install;;
        zsh) zsh_install;;
    esac
    
}

uninstal_package(){
    echo $@
}

parameter_counter=0
while getopts "i:u:h" arg; do
    case $arg in
        i)  install_package $OPTARG
        let parameter_counter+=1;;
        u)  uninstall $OPTARG
        let parameter_counter+=1;;
        h)  helpPanel;;
    esac
done

if [ $parameter_counter -eq 0 ];then
    helpPanel
fi



