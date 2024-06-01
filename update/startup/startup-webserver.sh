#!/bin/bash

#delay 30s
sleep 30

# UPDATE VHOST


#Update Nextcloud
clpctl vhost-template:delete --name='NextZEN-Nextcloud'
clpctl vhost-template:add --name='NextZEN-Nextcloud' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Nextcloud

#Update Jellyfin
clpctl vhost-template:delete --name='NextZEN-Jellyfin'
clpctl vhost-template:add --name='NextZEN-Jellyfin' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Jellyfin

# 1 Update OpenWRT 
clpctl vhost-template:delete --name='NextZEN-Router'
clpctl vhost-template:add --name='NextZEN-Router' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextFirewall

# 2 Update Proxmox
clpctl vhost-template:delete --name='NextZEN-Proxmox'
clpctl vhost-template:add --name='NextZEN-Proxmox' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Proxmox

# 3 Update Web clp
clpctl vhost-template:delete --name='NextZEN-Web'
clpctl vhost-template:add --name='NextZEN-Web' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextWeb

# 4 Update AdguardHome
clpctl vhost-template:delete --name='NextZEN-DNS'
clpctl vhost-template:add --name='NextZEN-DNS' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextDNS

# 5 Update Portainer
clpctl vhost-template:delete --name='NextZEN-Portainer'
clpctl vhost-template:add --name='NextZEN-Portainer' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Portainer

# 6 Update Webfile
#clpctl vhost-template:delete --name='NextZen-Webfile'
#clpctl vhost-template:add --name='NextZen-Webfile' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Webfile

# 7 Update Dashboard-Admin
clpctl vhost-template:delete --name='NextZEN-Admin'
clpctl vhost-template:add --name='NextZEN-Admin' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Admin

# 8 Update NAS
clpctl vhost-template:delete --name='NextZEN-NAS'
clpctl vhost-template:add --name='NextZEN-NAS' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-NAS

# 9 Update NASfile
clpctl vhost-template:delete --name='NextZEN-File'
clpctl vhost-template:add --name='NextZEN-File' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-NASfile

# 10 Update NCAIO
clpctl vhost-template:delete --name='NextZEN-NCAIO'
clpctl vhost-template:add --name='NextZEN-NCAIO' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-NCAIO

# 11 Update Pyload
clpctl vhost-template:delete --name='NextZEN-Get'
clpctl vhost-template:add --name='NextZEN-Get' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextGet

# 12 Update Wireguard
clpctl vhost-template:delete --name='NextZEN-VPN'
clpctl vhost-template:add --name='NextZEN-VPN' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextVPN

# 13 Update HomeAssistant
clpctl vhost-template:delete --name='NextZEN-HomeAssistant'
clpctl vhost-template:add --name='NextZEN-HomeAssistant' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-HomeAssistant

# 14 Update Proxmoxfile
#clpctl vhost-template:delete --name='NextZen-Proxmoxfile'
#clpctl vhost-template:add --name='NextZen-Proxmoxfile' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Proxmoxfile

# 15 Update CameraNVR
clpctl vhost-template:delete --name='NextZEN-CameraNVR'
clpctl vhost-template:add --name='NextZEN-CameraNVR' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-CameraNVR

#Update Vaultwarden
clpctl vhost-template:delete --name='NextZEN-Vaultwarden'
clpctl vhost-template:add --name='NextZEN-Vaultwarden' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Vaultwarden

#Update Syncthing
clpctl vhost-template:delete --name='NextZEN-Syncthing'
clpctl vhost-template:add --name='NextZEN-Syncthing' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Syncthing

#Update Radarr
#clpctl vhost-template:delete --name='NextZen-Radarr'
#clpctl vhost-template:add --name='NextZen-Radarr' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Radarr

#Update Sonarr
#clpctl vhost-template:delete --name='NextZen-Sonarr'
#clpctl vhost-template:add --name='NextZen-Sonarr' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Sonarr



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
     -v /NextZEN/smb.conf:/etc/samba/smb.conf\
     -p 139:139\
     -p 445:445\
     dperson/samba -u "root;Oxu7aUUb7waBLo53rMfNqfOo"
fi

NETWORK_NAME="Lan_Network"

# Kiểm tra xem mạng docker Lan_Network có tồn tại hay không
#if docker network inspect "$NETWORK_NAME" &> /dev/null; then
#  echo "Mạng $NETWORK_NAME đã tồn tại."
#else
#  # Nếu mạng không tồn tại, tạo mạng mới
#  echo "Mạng $NETWORK_NAME không tồn tại, đang tạo mạng mới..."
#  docker network create -d macvlan --subnet=10.0.0.0/24 --gateway=10.0.0.1 -o parent=enp6s18 $NETWORK_NAME
#  echo "Mạng $NETWORK_NAME đã được tạo thành công."
#fi

rm /tmp/startup-webserver.sh
rm startup-webserver.sh