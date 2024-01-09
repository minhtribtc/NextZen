#!/bin/bash
# thư mục gốc
TQH=/TQH
srv=/srv
mnt=/mnt
media=/media
DATA=/DATA
DATAFILES=/files/DATA
SYSTEMFILES=/files/SYSTEM
nextzen=/NextZen
nextzendata=/DATA/NextZen
DATAsrv=/srv/DATA
ProxmoxServer=/DATA/ProxmoxServer
WebServer=/DATA/WebServer

# Đường dẫn đầy đủ của thư mục srv
nas="/NextZen/nas"
# Đường dẫn đầy đủ của thư mục mnt
network="/NextZen/network"

# Đường dẫn đầy đủ của thư mục media
others="/NextZen/others"

#delay 30s
sleep 30

# Kiểm tra xem thư mục /NextZen/nas có tồn tại hay không
if [ -d "$nas" ]; then
    echo "Thư mục /NextZen/nas đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục /NextZen/nas không tồn tại, tạo liên kết đến thư mục NextZen trong thư mục srv
    ln -s /srv /NextZen/nas
    echo "Đã tạo liên kết đến thư mục /NextZen/nas trong thư mục srv với tên là nas-storage."
fi

# Kiểm tra xem thư mục network-mnt có tồn tại hay không
if [ -d "$network" ]; then
    echo "Thư mục network-storage đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục network-storage không tồn tại, tạo liên kết đến thư mục TQH trong thư mục mnt
    ln -s /mnt /NextZen/network
    echo "Đã tạo liên kết đến thư mục NextZen trong thư mục mnt với tên là network-storage."
fi

# Kiểm tra xem thư mục others-media có tồn tại hay không
if [ -d "$others" ]; then
    echo "Thư mục others-storage đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục others-storage không tồn tại, tạo liên kết đến thư mục DATA trong thư mục media
    ln -s /media /NextZen/others
    echo "Đã tạo liên kết đến thư mục TQH trong thư mục c với tên là others-storage."
fi

##### Kiểm tra xem thư mục /DATA/NextZen có tồn tại hay không
# if [ -d "$nextzendata" ]; then
    # echo "Thư mục nextzendata đã tồn tại. Không thực hiện thêm bước nào."
# else
    # # Nếu thư mục nextzendata không tồn tại, tạo liên kết đến thư mục DATA trong thư mục media
    # ln -s /NextZen /DATA/NextZen
    # echo "Đã tạo liên kết đến thư mục DATA trong thư mục NextZen với tên là NextZen."
# fi

# Kiểm tra xem thư mục DATAFILES có tồn tại hay không
if [ -d "$DATAFILES" ]; then
    echo "Thư mục DATAFILES đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục DATAFILES không tồn tại, tạo liên kết đến thư mục DATA trong thư mục files
    ln -s /DATA /files/DATA
    echo "Đã tạo liên kết đến thư mục DATA trong thư mục files với tên là DATA."
fi

# Kiểm tra xem thư mục SYSTEMFILES có tồn tại hay không
if [ -d "$SYSTEMFILES" ]; then
    echo "Thư mục SYSTEMFILES đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục SYSTEMFILES không tồn tại, tạo liên kết đến thư mục / trong thư mục files
    ln -s / /files/SYSTEM
    echo "Đã tạo liên kết đến thư mục / trong thư mục files với tên là SYSTEM."
fi

# Kiểm tra xem thư mục /srv/DATA có tồn tại hay không
if [ -d "$DATAsrv" ]; then
    echo "Thư mục /srv/DATA đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục /srv/DATA không tồn tại, tạo liên kết đến thư mục /srv/DATA trong thư mục /DATA
    ln -s /DATA /srv/DATA
    echo "Đã tạo liên kết đến thư mục /srv/DATA trong thư mục /DATA với tên là DATA."
fi

# Kiểm tra xem thư mục /DATA/ProxmoxServer có tồn tại hay không
if [ -d "$ProxmoxServer" ]; then
    echo "Thư mục ProxmoxServer đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục ProxmoxServer không tồn tại, tạo liên kết đến thư mục /DATA trong thư mục /mnt/ProxmoxServer
    ln -s /mnt/ProxmoxServer /DATA/ProxmoxServer
    echo "Đã tạo liên kết đến thư mục /DATA/ProxmoxServer trong thư mục srv /mnt/ProxmoxServer tên là ProxmoxServer."
fi

# Kiểm tra xem thư mục /DATA/WebServer có tồn tại hay không
if [ -d "$WebServer" ]; then
    echo "Thư mục WebServer đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục WebServer không tồn tại, tạo liên kết đến thư mục /DATA trong thư mục /mnt/WebServer
    ln -s /mnt/WebServer /DATA/WebServer
    echo "Đã tạo liên kết đến thư mục /DATA/WebServer trong thư mục srv /mnt/WebServer tên là WebServer."
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
