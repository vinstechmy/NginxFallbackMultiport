#!/bin/bash
clear
red() { echo -e "\\033[32;1m${*}\\033[0m"; }
IP=$(curl -s ipv4.icanhazip.com)
HOST="$(cat /usr/local/etc/xray/domain)"
date=$(date +"%d-%B-%Y")
ISPVPS=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
GREEN="\e[92;1m"
BLUE="\033[36m"
RED='\033[0;31m'
NC='\033[0m'

function BACKUPVPS() {
red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
orange='\e[0;33m'
NC='\e[0m'
clear
IP=$(wget -qO- icanhazip.com);
date=$(date +"%Y-%m-%d")
clear
echo " VPS Data Backup By Vinstechmy "
sleep 1
echo ""
clear
sleep 1
echo -e "[ ${green}INFO${NC} ] Processing Data Backup . . . "
mkdir -p /root/backup
sleep 1
clear
echo " Please Wait VPS Data Backup In Progress . . . "
cp -r /usr/local/etc/xray/*.json /root/backup/ >/dev/null 2>&1
cp -r /usr/local/etc/xray/configlogs /root/backup/ >/dev/null 2>&1
cp -r /home/vps/public_html /root/backup/public_html
cp -r /etc/cron.d /root/backup/cron.d &> /dev/null
cp -r /etc/crontab /root/backup/crontab &> /dev/null
cd /root
zip -r $IP-$date.zip backup > /dev/null 2>&1
rclone copy /root/$IP-$date.zip dr:backup/
url=$(rclone link dr:backup/$IP-$date.zip)
id=(`echo $url | grep '^https' | cut -d'=' -f2`)
link="https://drive.google.com/u/4/uc?id=${id}&export=download"
clear
echo -e "\033[1;37mVPS Data Backup By Vinstechmy\033[0m
\033[1;37mTelegram : https://t.me/Vinstechmy / @Vinstechmy\033[0m"
echo ""
echo "Please Copy Link Below & Save In Notepad"
echo ""
echo -e "Your VPS IP ( \033[1;37m$IP\033[0m )"
echo ""
echo -e "Your VPS Data Backup Password : \033[1;37m$InputPass\033[0m"
echo ""
echo -e "\033[1;37m$link\033[0m"
echo ""
echo "If you want to restore data, please enter the link above"
rm -rf /root/backup
rm -r /root/$IP-$date.zip
echo ""

}

function RESTOREVPS() {
red='\e[1;31m'
green='\e[0;32m'
purple='\e[0;35m'
orange='\e[0;33m'
NC='\e[0m'
clear
echo ""
echo " This Feature Can Only Be Used According To VPS Data With This Autoscript"
echo " Please Insert VPS Data Backup Link To Restore The Data"
echo ""
read -rp " Link File : " -e url
wget -O backup.zip "$url"
unzip /root/backup.zip &> /dev/null
rm -f backup.zip
sleep 1
echo -e "[ ${green}INFO${NC} ] Start Restore . . . "
cp -r /root/backup/*.json /usr/local/etc/xray/ &> /dev/null
cp -r /root/backup/configlogs /usr/local/etc/xray/ &> /dev/null
cp -r /root/backup/public_html /home/vps/ &> /dev/null
cp -r /root/backup/crontab /etc/ &> /dev/null
cp -r /root/backup/cron.d /etc/ &> /dev/null
rm -rf /root/backup
rm -f backup.zip
echo ""
echo -e "[ ${green}INFO${NC} ] VPS Data Restore Complete !"
echo ""
echo -e "[ ${green}INFO${NC} ] Restart All Service"
systemctl restart nginx
systemctl restart xray.service
systemctl restart xray@none.service
service cron restart
sleep 0.5
clear
echo ""
    echo -e "${green}VPS Data Restore Success !${NC}"

}

echo -e "\033[0;34m─────────────────────────────────────────\033[0m"
echo -e "\E[0;41;36m              BACKUP & RESTORE           \E[0m"
echo -e "\033[0;34m─────────────────────────────────────────\033[0m"
echo -e ""
echo -e " [\e[36m 1 \e[0m] ${RED}• ${NC} Backup Data VPS"
echo -e " [\e[36m 2 \e[0m] ${RED}• ${NC} Restore Data VPS"
echo -e " [\e[36m 3 \e[0m] ${RED}• ${NC} Back To Main Menu"
echo -e ""
echo -e "\033[0;34m─────────────────────────────────────────\033[0m"
echo -e ""
read -p " Select Menu : " OPT_MENU
echo -e ""
case $OPT_MENU in
1)
    BACKUPVPS
    ;;
2)
    RESTOREVPS
    ;;
3)
    menu
    ;;
*)
    echo -e "Please enter an correct number !"
    sleep 1
    get-backres
    ;;
esac
echo ""
read -n 1 -s -r -p "Press any key to back on menu"

menu