#!/bin/bash

    mkdir /root/hinaswifi

    wget -nc -P /root/hinaswifi/ https://mirror.ghproxy.com/https://github.com/benbenhuo/hinaswifi/raw/main/hi_kernel-mv100-0808.bin
    wget -nc -P /root/hinaswifi/ https://mirror.ghproxy.com/https://github.com/benbenhuo/hinaswifi/raw/main/wifi_install.sh
    wget -nc -P /root/hinaswifi/ https://mirror.ghproxy.com/https://github.com/benbenhuo/hinaswifi/raw/main/hiwifi.md5sum
    wget -nc -P /root/hinaswifi/ https://mirror.ghproxy.com/https://github.com/benbenhuo/hinaswifi/raw/main/rtl8188ftv-0808.tar.gz
    wget -nc -P /root/hinaswifi/ https://mirror.ghproxy.com/https://github.com/benbenhuo/hinaswifi/raw/main/rtl8188etv-0808.tar.gz
    sed -i "s|repo.huaweicloud.com|mirrors.tuna.tsinghua.edu.cn|g" /etc/apt/sources.list
    chmod 777 /root/hinaswifi/wifi_install.sh
    apt update && apt install kmod
    
    cd /root/hinaswifi 
    md5sum rtl8188etv-0808.tar.gz rtl8188ftv-0808.tar.gz wifi_install.sh hi_kernel-mv100-0808.bin > hiwifilocal.md5sum
    md5sum hiwifilocal.md5sum -c hiwifi.md5sum
if [ $? -ne 0 ];then
    echo "数据下载异常或者MD5校验未通过"
    cd
    rm -r /root/hinaswifi
    exit

set -e
else
    echo "数据下载成功并且MD5校验通过"
    dd if=/root/hinaswifi/hi_kernel-mv100-0808.bin of=/dev/mmcblk0p6
fi
    echo "安装后会自动重启，请重启后按nmtui并回车，然后按a并回车选择连接的wifi"
    echo -e "$选择驱动（RTL8188FTV按y）（RTL8188ETV按n）${NC}"

read -p "(y/n): " response

if [ "$response" = "y" ]; then
    cd /root/hinaswifi
    bash ./wifi_install.sh -f rtl8188ftv-0808.tar.gz
    cd

elif [ "$response" = "n" ]; then
    cd /root/hinaswifi
    bash ./wifi_install.sh -f rtl8188etv-0808.tar.gz
    cd

fi