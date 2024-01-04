#!/bin/bash
# thư mục gốc
TQH=/TQH
srv=/srv
mnt=/mnt
media=/media
DATA=/DATA
DATAFILES=/files/DATA
SYSTEMFILES=/files/SYSTEM
# Đường dẫn đầy đủ của thư mục srv
nas="/DATA/nas-storage"
# Đường dẫn đầy đủ của thư mục mnt
network="/DATA/network-storage"

# Đường dẫn đầy đủ của thư mục media
others="/DATA/others-storage"

#delay 30s
sleep 30

# Kiểm tra xem thư mục nas-storage có tồn tại hay không
if [ -d "$nas" ]; then
    echo "Thư mục nas-storage đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục nas-storage không tồn tại, tạo liên kết đến thư mục DATA trong thư mục srv
    ln -s "$srv" "$DATA/nas-storage"
    echo "Đã tạo liên kết đến thư mục DATA trong thư mục srv với tên là nas-storage."
fi

# Kiểm tra xem thư mục network-storage có tồn tại hay không
if [ -d "$network" ]; then
    echo "Thư mục network-storage đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục network-storage không tồn tại, tạo liên kết đến thư mục TQH trong thư mục mnt
    ln -s "$mnt" "$DATA/network-storage"
    echo "Đã tạo liên kết đến thư mục DATA trong thư mục mnt với tên là network-storage."
fi

# Kiểm tra xem thư mục others-storage có tồn tại hay không
if [ -d "$others" ]; then
    echo "Thư mục others-storage đã tồn tại. Không thực hiện thêm bước nào."
else
    # Nếu thư mục others-storage không tồn tại, tạo liên kết đến thư mục DATA trong thư mục media
    ln -s "$media" "$DATA/others-storage"
    echo "Đã tạo liên kết đến thư mục TQH trong thư mục c với tên là others-storage."
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

rm update.sh
