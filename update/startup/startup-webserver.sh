#!/bin/bash

#Update Nextcloud
clpctl vhost-template:delete --name='NextZen-Nextcloud'
clpctl vhost-template:add --name='NextZen-Nextcloud' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Nextcloud

#Update Jellyfin
clpctl vhost-template:delete --name='NextZen-Jellyfin'
clpctl vhost-template:add --name='NextZen-Jellyfin' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Jellyfin

#Update OpenWRT
clpctl vhost-template:delete --name='NextZen-OpenWRT'
clpctl vhost-template:add --name='NextZen-OpenWRT' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-OpenWRT

#Update Proxmox
clpctl vhost-template:delete --name='NextZen-Proxmox'
clpctl vhost-template:add --name='NextZen-Proxmox' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Proxmox

#Update AdguardHome
clpctl vhost-template:delete --name='NextZen-AdguardHome'
clpctl vhost-template:add --name='NextZen-AdguardHome' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-AdguardHome

#Update Portainer
clpctl vhost-template:delete --name='NextZen-Portainer'
clpctl vhost-template:add --name='NextZen-Portainer' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Portainer

#Update NAS
clpctl vhost-template:delete --name='NextZen-NAS'
clpctl vhost-template:add --name='NextZen-NAS' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-NAS

#Update Wireguard
clpctl vhost-template:delete --name='NextZen-Wireguard'
clpctl vhost-template:add --name='NextZen-Wireguard' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Wireguard

#Update HomeAssistant
clpctl vhost-template:delete --name='NextZen-HomeAssistant'
clpctl vhost-template:add --name='NextZen-HomeAssistant' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-HomeAssistant

#Update CameraNVR
clpctl vhost-template:delete --name='NextZen-CameraNVR'
clpctl vhost-template:add --name='NextZen-CameraNVR' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-CameraNVR

#Update CameraNVR
clpctl vhost-template:delete --name='NextZen-Vaultwarden'
clpctl vhost-template:add --name='NextZen-CameraNVR' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Vaultwarden


rm startup-webserver.sh
