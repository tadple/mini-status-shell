#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"


cd "$(
    cd "$(dirname "$0")" || exit
    pwd
)" || exit

#fonts color
Green="\033[32m"
Red="\033[31m"
# Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"


check_system() {
    if [[ "${release}" == "centos" ]]; then
        INS="yum"
    elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
        INS="apt"
        $INS update
    else
        echo -e "${Error} ${RedBG} 当前系统为 ${release}不在支持的系统列表内，安装中断 ${Font}"
        exit 1
    fi
}
    
mini_status(){
     read -p "请输入实例IP和端口（eg:1.1.1.1:8080) : " ip
     read -p "请输入实例密码 : " mima
    if [[ "${ID}" == "centos" ]]; then
      ${INS} install npm -y && npm install mini-status -g
      nohup mini-status -a ${ip} -u /status -p ${mima} &
    else
      ${INS} install npm -y && npm install mini-status -g
      
      nohup mini-status -a ${ip} -u /status -p ${mima} &
    fi
    echo -e "请在小程序中填写接口地址：${ip}/status Password:${mima}"

}
    
    
    
    
    
    #############系统检测组件#############

#检查系统
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
}

#检查Linux版本
check_version(){
	if [[ -s /etc/redhat-release ]]; then
		version=`grep -oE  "[0-9.]+" /etc/redhat-release | cut -d . -f 1`
	else
		version=`grep -oE  "[0-9.]+" /etc/issue | cut -d . -f 1`
	fi
	bit=`uname -m`
	if [[ ${bit} = "x86_64" ]]; then
		bit="x64"
	else
		bit="x32"
	fi
}



#############系统检测组件#############
check_sys
check_version
check_system
[[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && [[ ${release} != "centos" ]] && echo -e "${Error} 本脚本不支持当前系统 ${release} !" && exit 1
mini_status

