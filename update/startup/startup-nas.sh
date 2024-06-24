#!/bin/bash
# thư mục gốc
srv=/srv
mnt=/mnt
media=/media
DATA=/DATA
mntDATA=/mnt/DATA
#SYSTEMNextZen=/NextZen/SYSTEM
nextzen=/NextZen
#ProxmoxServer=/mnt/ProxmoxServer
#Webserver=/NextZen/Webserver

#delay 30s
sleep 30




NETWORK_NAME="Lan_Network"

# Kiểm tra xem mạng docker Lan_Network có tồn tại hay không
if docker network inspect "$NETWORK_NAME" &> /dev/null; then
  echo "Mạng $NETWORK_NAME đã tồn tại."
else
  # Nếu mạng không tồn tại, tạo mạng mới
  echo "Mạng $NETWORK_NAME không tồn tại, đang tạo mạng mới..."
  docker network create -d macvlan --subnet=10.0.0.0/24 --gateway=10.0.0.1 -o parent=enp6s18 $NETWORK_NAME
  echo "Mạng $NETWORK_NAME đã được tạo thành công."
fi

rm startup-nas.sh
rm /tmp/startup-nas.sh
