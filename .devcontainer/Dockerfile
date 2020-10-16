FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-12

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=node
ARG ENABLE_NONROOT_DOCKER="true"
ARG SOURCE_SOCKET=/var/run/docker-host.sock
ARG TARGET_SOCKET=/var/run/docker.sock
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    && bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "${SOURCE_SOCKET}" "${TARGET_SOCKET}" "${USERNAME}" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

COPY ./mount-overlay* /usr/local/share/
COPY ./fix-bind-mount.sh /usr/local/share/
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]
