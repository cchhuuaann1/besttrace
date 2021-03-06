#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#fonts color
Green="\033[32m"
Red="\033[31m"
# Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#notification information
# Info="${Green}[信息]${Font}"
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

source '/etc/os-release'

VERSION=$(echo "${VERSION}" | awk -F "[()]" '{print $2}')

xitongjiance() {
    if [[ "${ID}" == "centos" && ${VERSION_ID} -ge 7 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Centos ${VERSION_ID} ${VERSION} ${Font}"
        INS="yum"
	$INS update
	$INS install wget zip -y
    elif [[ "${ID}" == "debian" && ${VERSION_ID} -ge 8 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Debian ${VERSION_ID} ${VERSION} ${Font}"
        INS="apt"
        $INS update
	$INS install wget zip -y
    elif [[ "${ID}" == "ubuntu" && $(echo "${VERSION_ID}" | cut -d '.' -f1) -ge 16 ]]; then
        echo -e "${OK} ${GreenBG} 当前系统为 Ubuntu ${VERSION_ID} ${UBUNTU_CODENAME} ${Font}"
        INS="apt"
        $INS update
	$INS install wget zip -y
    else
        echo -e "${Error} ${RedBG} 当前系统为 ${ID} ${VERSION_ID} 不在支持的系统列表内，安装中断 ${Font}"
        exit 1
    fi	
}

root() {
    if [ 0 == $UID ]; then
        echo -e "${OK} ${GreenBG} 当前用户是root用户，进入安装流程 ${Font}"
        sleep 3
    else
        echo -e "${Error} ${RedBG} 当前用户不是root用户，请切换到root用户后重新执行脚本 ${Font}"
        exit 1
    fi
}

xiazai(){
    wget https://cdn.ipip.net/17mon/besttrace4linux.zip
    unzip besttrace4linux.zip
    chmod +x besttrace
    echo -e "${OK} ${GreenBG} 安装完成 ${Font}"
}

anzhuang(){
    root
    xitongjiance
    xiazai
}
menu(){
    echo -e "\t———————TCP 路由追踪脚本———————"
    echo -e "\t—————脚本小子 晋M联通出品—————"
    echo -e "\thttps://github.com/cchhuuaann1\n"
    echo -e "${Green}1.${Font}  安装路由追踪"
    echo -e "${Green}2.${Font}  路由追踪"
    echo -e "${Green}3.${Font}  退出脚本"

    read -rp "请输入数字：" shuzi
    case $shuzi in
    1)
       anzhuang
       ;;
    2)
       read -rp "请输入IP地址" ip
       ./besttrace -q1 -g cn -T ${ip}
       ;;
     3)
       exit 0
       ;;
     *)
       echo -e "${RedBG}请输入正确的数字${Font}"
	;;
    esac
}

menu
