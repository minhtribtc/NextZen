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


#update nextcloud ip
# Đường dẫn đến tệp cần kiểm tra
FILE="/NextZEN/App/System/volumes/nextcloud_aio_nextcloud/_data/config/config.php"

# Chuỗi đầu tiên để kiểm tra
LOCAL_GATEWAY="0 => '127.0.0.1'"
# Lệnh để lấy giá trị Gateway từ Docker
NEXTCLOUD_BRIDGE_GATEWAY=$(docker network inspect nextcloud-aio | jq -r '.[].IPAM.Config[].Gateway')
# ip webserver
WEBSERVER="10.0.0.3"
# Kiểm tra xem tệp có tồn tại không
if [ -f "$FILE" ]; then
    echo "Tệp '$FILE' tồn tại."

    # Kiểm tra chuỗi đầu tiên
    if grep -qF "$LOCAL_GATEWAY" "$FILE"; then
        echo "Chuỗi '$LOCAL_GATEWAY' đã tồn tại trong tệp."

        # Kiểm tra xem giá trị Gateway đã tồn tại chưa
        if grep -qF "$NEXTCLOUD_BRIDGE_GATEWAY" "$FILE"; then
            echo "Chuỗi '$NEXTCLOUD_BRIDGE_GATEWAY' đã tồn tại trong tệp không cần sửa."
        else
            # Định dạng lại giá trị cho phù hợp với chèn vào tệp
            FORMATTED_NEXTCLOUD_BRIDGE_GATEWAY="    2 => '$NEXTCLOUD_BRIDGE_GATEWAY',"
            echo "Chuỗi '$NEXTCLOUD_BRIDGE_GATEWAY' không tồn tại trong tệp. Chèn ngay sau '$LOCAL_GATEWAY'."
            # Chèn chuỗi giá trị mới sau chuỗi đầu tiên
            sed -i "/$LOCAL_GATEWAY/a\\$FORMATTED_NEXTCLOUD_BRIDGE_GATEWAY" "$FILE"
            echo "Chuỗi '$FORMATTED_NEXTCLOUD_BRIDGE_GATEWAY' đã được chèn vào tệp."
        fi
        # Kiểm tra xem giá trị WEBSERVER đã tồn tại chưa
        if grep -qF "$WEBSERVER" "$FILE"; then
            echo "Chuỗi '$WEBSERVER' đã tồn tại trong tệp không cần sửa."
        else
            # Định dạng lại giá trị cho phù hợp với chèn vào tệp
            FORMATTED_WEBSERVER="    3 => '$WEBSERVER',"
            echo "Chuỗi '$WEBSERVER' không tồn tại trong tệp. Chèn ngay sau '$LOCAL_GATEWAY'."
            # Chèn chuỗi giá trị mới sau chuỗi đầu tiên
            sed -i "/$LOCAL_GATEWAY/a\\$FORMATTED_WEBSERVER" "$FILE"
            echo "Chuỗi '$FORMATTED_WEBSERVER' đã được chèn vào tệp."
        fi
    else
        echo "Chuỗi '$LOCAL_GATEWAY' không tồn tại trong tệp. Không thực hiện hành động nào."
    fi

else
    echo "Tệp '$FILE' không tồn tại cần cài đặt nextcloud trước."
fi



NETWORK_NAME="Lan_Network"

# Kiểm tra xem mạng docker Lan_Network có tồn tại hay không
if docker network inspect "$NETWORK_NAME" &> /dev/null; then
  echo "Mạng $NETWORK_NAME đã tồn tại."
else
  # Nếu mạng không tồn tại, tạo mạng mới
  echo "Mạng $NETWORK_NAME không tồn tại, đang tạo mạng mới..."
  docker network create -d macvlan --subnet=10.0.0.0/24 --gateway=10.0.0.1 -o parent=br0 $NETWORK_NAME
  echo "Mạng $NETWORK_NAME đã được tạo thành công."
fi

rm startup-nas.sh
rm /tmp/startup-nas.sh
