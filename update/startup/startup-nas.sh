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
# Đường dẫn đầy đủ của thư mục srv
nas="/NextZen/nas"
# Đường dẫn đầy đủ của thư mục mnt
network="/NextZen/network"

# Đường dẫn đầy đủ của thư mục media
others="/NextZen/others"

#delay 30s
sleep 30

# Kiểm tra xem thư mục nas-storage có tồn tại hay không
if [ -d "$nas" ]; then
    echo "Thư mục nas-storage đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục nas-storage không tồn tại, tạo liên kết đến thư mục NextZen trong thư mục srv
    ln -s /srv /NextZen/nas
    echo "Đã tạo liên kết đến thư mục NextZen trong thư mục srv với tên là nas-storage."
fi

# Kiểm tra xem thư mục network-storage có tồn tại hay không
if [ -d "$network" ]; then
    echo "Thư mục network-storage đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục network-storage không tồn tại, tạo liên kết đến thư mục TQH trong thư mục mnt
    ln -s /mnt /NextZen/network
    echo "Đã tạo liên kết đến thư mục NextZen trong thư mục mnt với tên là network-storage."
fi

# Kiểm tra xem thư mục others-storage có tồn tại hay không
if [ -d "$others" ]; then
    echo "Thư mục others-storage đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục others-storage không tồn tại, tạo liên kết đến thư mục DATA trong thư mục media
    ln -s /media /NextZen/others
    echo "Đã tạo liên kết đến thư mục TQH trong thư mục c với tên là others-storage."
fi

# Kiểm tra xem thư mục /DATA/NextZen có tồn tại hay không
if [ -d "$nextzendata" ]; then
    echo "Thư mục nextzendata đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục nextzendata không tồn tại, tạo liên kết đến thư mục DATA trong thư mục media
    ln -s /NextZen /DATA/NextZen
    echo "Đã tạo liên kết đến thư mục DATA trong thư mục NextZen với tên là NextZen."
fi
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

rm startup-nas.sh
