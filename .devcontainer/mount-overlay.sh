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

WORKSPACE_FOLDER="$(head -n 1 "${SCRIPT_FOLDER}/mount-overlay-folder")"
CONTAINER_WORKSPACE_FOLDER="${CONTAINER_WORKSPACE_FOLDER:-"$USER_HOME/workspace/${WORKSPACE_FOLDER}"}"
CONTAINER_WORKSPACE_ROOT="$(cd "${CONTAINER_WORKSPACE_FOLDER}/.." && pwd)"
OVERLAY_WORK_FOLDER="${CONTAINER_WORKSPACE_ROOT}/.work"
OVERLAY_MERGED_FOLDER="${CONTAINER_WORKSPACE_FOLDER}"

cat << EOF
WORKSPACE_FOLDER: ${WORKSPACE_FOLDER}
CONTAINER_WORKSPACE_FOLDER: ${CONTAINER_WORKSPACE_FOLDER}
CONTAINER_WORKSPACE_ROOT: ${CONTAINER_WORKSPACE_ROOT}
OVERLAY_WORK_FOLDER: ${OVERLAY_WORK_FOLDER}
OVERLAY_MERGED_FOLDER: ${OVERLAY_MERGED_FOLDER}
EOF

#sudo rm -rf "${OVERLAY_WORK_FOLDER}"
sudo mkdir -p "/cache" "/cache/subfolder" "${OVERLAY_WORK_FOLDER}"
sudo chown ${USERNAME}:${USERNAME}  "/cache"
echo "yep" > /cache/overlay-works.txt
echo "yep" > /cache/subfolder/overlay-works-2.txt
sudo chown -R ${USERNAME}:${USERNAME} "/cache" "${OVERLAY_WORK_FOLDER}"

sudo mount -t overlay overlay -o "lowerdir=/cache,upperdir=${OVERLAY_MERGED_FOLDER},workdir=${OVERLAY_WORK_FOLDER}" "${OVERLAY_MERGED_FOLDER}"

touch "${CONTAINER_WORKSPACE_FOLDER}/*"

exec "$@"
