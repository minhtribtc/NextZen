#!/bin/bash

#Update Nextcloud
clpctl vhost-template:delete --name='NextZen-Nextcloud'
clpctl vhost-template:add --name='NextZen-Nextcloud' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/NextZen-Nextcloud

#Update Jellyfin
clpctl vhost-template:delete --name='NextZen-Jellyfin'
clpctl vhost-template:add --name='NextZen-Jellyfin' --file=https://raw.githubusercontent.com/minhtribtc/NextZen/main/update/vhost/default



rm startup-webserver.sh
