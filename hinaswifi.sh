#!/bin/bash

set -e
rm -r /root/hainaswifi
mkdir /root/hainaswifi

wget -P /root/hainaswifi/ https://mirror.ghproxy.com/https://github.com/benbenhuo/hinaswifi/raw/main/hi_kernel-mv100-0808.bin
wget -P /root/hainaswifi/ https://mirror.ghproxy.com/https://github.com/benbenhuo/hinaswifi/raw/main/wifi_install.sh
wget -P /root/hainaswifi/ https://mirror.ghproxy.com/https://github.com/benbenhuo/hinaswifi/raw/main/hiwifi.md5sum
wget -P /root/hainaswifi/ https://mirror.ghproxy.com/https://github.com/benbenhuo/hinaswifi/raw/main/rtl8188ftv-0808.tar.gz
wget -P /root/hainaswifi/ https://mirror.ghproxy.com/https://github.com/benbenhuo/hinaswifi/raw/main/rtl8188etv-0808.tar.gz
chmod 777 /root/hainaswifi/wifi_install.sh
apt update && apt install kmod

cd /root/hainaswifi 
md5sum rtl8188etv-0808.tar.gz rtl8188ftv-0808.tar.gz wifi_install.sh hi_kernel-mv100-0808.bin -c hiwifi.md5sum
if [ $? -ne 0 ];then
echo "数据下载异常或者MD5校验未通过"
cd
exit

else
echo "数据下载成功并且MD5校验通过"
dd if=/root/hainaswifi/hi_kernel-mv100-0808.bin of=/dev/mmcblk0p6
echo -e "$选择驱动（RTL8188FTV按y）（RTL8188ETV按n）${NC}"

read -p "(y/n): " response

if [ "$response" = "y" ]; then
bash wifi_install.sh -f rtl8188ftv-0808.tar.gz

elif [ "$response" = "n" ]; then
bash wifi_install.sh -f rtl8188etv-0808.tar.gz

fi

echo "确认安装完成后按y，自动重启后按nmtui回车，按a回车选择连接的wifi"

echo "确认失败后按n退出脚本"
echo -e "$（y/n）${NC}"

read -p "(y/n): " response

if [ "$response" = "y" ]; then
reboot

elif [ "$response" = "n" ]; then
exit

fi
