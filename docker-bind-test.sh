#!/bin/bash
.devcontainer/fix-bind-mount.sh
.devcontainer/mount-overlay.sh
docker run -it --rm -v $(pwd):/workspace alpine sh -c 'ls /workspace && ls /workspace/subfolder'
