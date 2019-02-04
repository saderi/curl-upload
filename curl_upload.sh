#!/usr/bin/env bash
set -e

# This is for cPanel webdisk
WEBDISK_HOST=https://$HOST_DOMAIN_NAME:2078
HOST_USERNAME=user_host_username
HOST_PASSWORD=your_host_password
REMOTE_PATH='/public_html'

LOCAL_PATH='./dist'

mapfile -t LS_TREE < <(tree -ifp --noreport $LOCAL_PATH)
for (( i=1; i<${#LS_TREE[@]}; i++ ));
do 
    if [ ${LS_TREE[i]:1:1} = 'd' ]; then
        # Create folders
        DIR=$(echo ${LS_TREE[i]} | awk {'print $2'})
        DIR_NAME=${DIR#"$LOCAL_PATH"}
        curl -u $HOST_USERNAME:$HOST_PASSWORD \
             -X MKCOL "$WEBDISK_HOST$REMOTE_PATH$DIR_NAME" >/dev/null 2>&1
    fi
    if [ ${LS_TREE[i]:1:1} = '-' ]; then
        # Upload files
        LOCAL_FILE=$(echo ${LS_TREE[i]} | awk {'print $2'})
        FILE_PATH=${LOCAL_FILE#"$LOCAL_PATH"}
        FILE_NAME=$(echo ${LS_TREE[i]} | awk {'print $2'} | tr "/" " " | awk '{print $NF}')
        REMOTE_DIR_NAME=$(echo ${FILE_PATH%"$FILE_NAME"})
        curl  -u $HOST_USERNAME:$HOST_PASSWORD \
              -T $LOCAL_FILE \
              "$WEBDISK_HOST$REMOTE_PATH$REMOTE_DIR_NAME" >/dev/null 2>&1
    fi
done

