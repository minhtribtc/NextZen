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


# Kiểm tra xem thư mục mntDATA có tồn tại hay không
if [ -d "$mntDATA" ]; then
    echo "Thư mục mntDATA đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục mntDATA không tồn tại, tạo liên kết đến thư mục DATA trong thư mục mnt
    ln -s /DATA /mnt/DATA
    echo "Đã tạo liên kết đến thư mục DATA trong thư mục mnt với tên là DATA."
fi

# Kiểm tra xem thư mục /DATA có tồn tại hay không
if [ -d "$DATA" ]; then
    echo "Thư mục /DATA đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục /DATA không tồn tại, tắt NextZenOS
    sudo systemctl stop casaos*.service
    echo "Đã tắt NextZenOS vui lòng chọn vùng lưu trữ mặc định"
fi

# kiểm tra portainer_agent có chạy hay không
if docker inspect --format '{{.State.Running}}' portainer_agent 2>/dev/null | grep -q "true"; then
    echo "portainer_agent đang chạy. Không cần thực hiện thêm bước nào."
else
    echo "portainer_agent không đang chạy. Đang xoá container và khởi động lại docker..."
    docker rm portainer_agent 2>/dev/null || echo "Không thể xoá portainer_agent. Có thể container không tồn tại."
    systemctl restart docker
    docker run -d \
      -p 9001:9001 \
      --name portainer_agent \
      --restart=always \
      -v /var/run/docker.sock:/var/run/docker.sock \
      -v /var/lib/docker/volumes:/var/lib/docker/volumes \
      portainer/agent:2.19.2
    
fi

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
