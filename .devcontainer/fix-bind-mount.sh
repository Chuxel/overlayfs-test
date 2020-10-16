#!/bin/bash
SCRIPT_FOLDER="$(cd "$(dirname $0)" && pwd)"
if [ -f "${SCRIPT_FOLDER}/mount-overlay-user" ]; then
    USERNAME="$(head -n 1 "${SCRIPT_FOLDER}/mount-overlay-user")"
    USER_HOME="/home/$USERNAME"
else 
    USERNAME="root"
    USER_HOME=/root
fi

WORKSPACE_PATH_IN_CONTAINER="$USER_HOME/workspace"
WORKSPACE_PATH_ON_HOST="/var/lib/docker/vsonlinemount/workspace"
VM_CONTAINER_WORKSPACE_PATH=/vm-host/$WORKSPACE_PATH_IN_CONTAINER
VM_CONTAINER_WORKSPACE_BASE_FOLDER=$(dirname $VM_CONTAINER_WORKSPACE_PATH)
VM_HOST_WORKSPACE_PATH=/vm-host/$WORKSPACE_PATH_ON_HOST

echo -e "Workspace path in container: ${WORKSPACE_PATH_IN_CONTAINER}\nWorkspace path on host: ${WORKSPACE_PATH_ON_HOST}"
docker run --rm -v /:/vm-host alpine sh -c " \
    if [ -d "${VM_HOST_WORKSPACE_PATH}" ]; then echo \"${VM_HOST_WORKSPACE_PATH} not-found. Aborting.\" && return 0; fi
    if [ -L "${VM_CONTAINER_WORKSPACE_PATH}" ]; then echo \"${WORKSPACE_PATH_IN_CONTAINER} already exists on host. Aborting.\" && return 0; fi
    apk add coreutils > /dev/null \
    && mkdir -p $VM_CONTAINER_WORKSPACE_BASE_FOLDER \
    && cd $VM_CONTAINER_WORKSPACE_BASE_FOLDER \
    && ln -s \$(realpath --relative-to='.' $VM_HOST_WORKSPACE_PATH) .\
    && echo 'Symlink created!'"

exec "$@"
