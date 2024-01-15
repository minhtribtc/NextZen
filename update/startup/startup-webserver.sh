#!/bin/bash

#delay 30s
sleep 30

# UPDATE VHOST


#Update Nextcloud
clpctl vhost-template:delete --name='NextZen-Nextcloud'
clpctl vhost-template:add --name='NextZen-Nextcloud' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Nextcloud

#Update Jellyfin
clpctl vhost-template:delete --name='NextZen-Jellyfin'
clpctl vhost-template:add --name='NextZen-Jellyfin' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Jellyfin

# 1 Update OpenWRT 
clpctl vhost-template:delete --name='NextZen-OpenWRT'
clpctl vhost-template:add --name='NextZen-OpenWRT' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-OpenWRT

# 2 Update Proxmox
clpctl vhost-template:delete --name='NextZen-Proxmox'
clpctl vhost-template:add --name='NextZen-Proxmox' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Proxmox

# 3 Update Web clp
clpctl vhost-template:delete --name='NextZen-Web'
clpctl vhost-template:add --name='NextZen-Web' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Web

# 4 Update AdguardHome
clpctl vhost-template:delete --name='NextZen-AdguardHome'
clpctl vhost-template:add --name='NextZen-AdguardHome' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-AdguardHome

# 5 Update Portainer
clpctl vhost-template:delete --name='NextZen-Portainer'
clpctl vhost-template:add --name='NextZen-Portainer' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Portainer

# 6 Update Webfile
clpctl vhost-template:delete --name='NextZen-Webfile'
clpctl vhost-template:add --name='NextZen-Webfile' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Webfile

# 7 Update Dashboard-Admin
clpctl vhost-template:delete --name='NextZen-Admin'
clpctl vhost-template:add --name='NextZen-Admin' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Admin

# 8 Update NAS
clpctl vhost-template:delete --name='NextZen-NAS'
clpctl vhost-template:add --name='NextZen-NAS' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-NAS

# 9 Update NASfile
clpctl vhost-template:delete --name='NextZen-NASfile'
clpctl vhost-template:add --name='NextZen-NASfile' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-NASfile

# 10 Update NCAIO
clpctl vhost-template:delete --name='NextZen-NCAIO'
clpctl vhost-template:add --name='NextZen-NCAIO' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-NCAIO

# 11 Update Jellyfin
clpctl vhost-template:delete --name='NextZen-Jellyfin'
clpctl vhost-template:add --name='NextZen-Jellyfin' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Jellyfin

# 12 Update Wireguard
clpctl vhost-template:delete --name='NextZen-Wireguard'
clpctl vhost-template:add --name='NextZen-Wireguard' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Wireguard

# 13 Update HomeAssistant
clpctl vhost-template:delete --name='NextZen-HomeAssistant'
clpctl vhost-template:add --name='NextZen-HomeAssistant' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-HomeAssistant

# 14 Update Proxmoxfile
clpctl vhost-template:delete --name='NextZen-Proxmoxfile'
clpctl vhost-template:add --name='NextZen-Proxmoxfile' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Proxmoxfile

# 15 Update CameraNVR
clpctl vhost-template:delete --name='NextZen-CameraNVR'
clpctl vhost-template:add --name='NextZen-CameraNVR' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-CameraNVR

#Update Vaultwarden
clpctl vhost-template:delete --name='NextZen-Vaultwarden'
clpctl vhost-template:add --name='NextZen-Vaultwarden' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Vaultwarden


# UPDATE LOCAL WEB URL

#share SMB to NAS
if docker inspect --format '{{.State.Running}}' share-to-nas 2>/dev/null | grep -q "true"; then
    echo "share-to-nas đang chạy. Không cần thực hiện thêm bước nào."
else
    echo "share-to-nas không đang chạy. Đang xoá container và khởi động lại docker..."
    docker rm share-to-nas 2>/dev/null || echo "Không thể xoá share-to-nas. Có thể container không tồn tại."
    #share to NAS
    docker run -d --restart=always\
     --name share-to-nas\
     -v /home:/srv/Website\
     -v /DATA/AppData:/srv/AppData\
     -v /NextZen/smb.conf:/etc/samba/smb.conf\
     -p 139:139\
     -p 445:445\
     dperson/samba -u "root;Oxu7aUUb7waBLo53rMfNqfOo"
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

rm /tmp/startup-webserver.sh
rm startup-webserver.sh
