#!/bin/bash
set -e
SCRIPT_FOLDER="$(cd "$(dirname $0)" && pwd)"
if [ -f "${SCRIPT_FOLDER}/mount-overlay-user" ]; then
    USERNAME="$(head -n 1 "${SCRIPT_FOLDER}/mount-overlay-user")"
    USER_HOME="/home/$USERNAME"
else 
    USERNAME="root"
    USER_HOME=/root
fi

OVERLAY_WORK_FOLDER="$USER_HOME/workspace/work"
#OVERLAY_WORK_FOLDER="/work"
WORKSPACE_FOLDER="$(head -n 1 "${SCRIPT_FOLDER}/mount-overlay-folder")"
OVERLAY_MERGED_FOLDER="$USER_HOME/workspace/${WORKSPACE_FOLDER}"
#OVERLAY_MERGED_FOLDER="$USER_HOME/workspace"

#sudo rm -rf "${OVERLAY_WORK_FOLDER}"
sudo mkdir -p "/cache" "${OVERLAY_WORK_FOLDER}"
echo "yep" > /cache/overlay-works.txt
echo "yep" > /cache/overlay-works-2.txt
sudo chown -R ${USERNAME}:${USERNAME} "/cache" "${OVERLAY_WORK_FOLDER}"

sudo mount -t overlay overlay -o "lowerdir=/cache,upperdir=${OVERLAY_MERGED_FOLDER},workdir=${OVERLAY_WORK_FOLDER}" "${OVERLAY_MERGED_FOLDER}"

exec "$@"
