######## INSTALL ########

# Set the base image
FROM ubuntu:24.04

# Set environment variables
ENV USER=root
ENV HOME=/root

# Set working directory
WORKDIR $HOME

# Insert Steam prompt answers
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections \
 && echo steam steam/license note '' | debconf-set-selections

# Update the repository and install SteamCMD
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg --add-architecture i386 \
 && apt-get update -y \
 && apt-get install -y --no-install-recommends ca-certificates locales steamcmd wget \
 && rm -rf /var/lib/apt/lists/*

# Add unicode support
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8'
ENV LANGUAGE='en_US:en'

# Create symlink for executable
RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd

# Update SteamCMD and verify latest version
RUN steamcmd +login anonymous +quit

# Fix missing directories and libraries
RUN mkdir -p $HOME/.steam \
 && ln -s $HOME/.local/share/Steam/steamcmd/linux32 $HOME/.steam/sdk32 \
 && ln -s $HOME/.local/share/Steam/steamcmd/linux64 $HOME/.steam/sdk64 \
 && ln -s $HOME/.steam/sdk32/steamclient.so $HOME/.steam/sdk32/steamservice.so \
 && ln -s $HOME/.steam/sdk64/steamclient.so $HOME/.steam/sdk64/steamservice.so

# Install Barotrauma Dedicated Server
ARG WORKDIR="/BarotraumaDedicatedServer"
WORKDIR "${WORKDIR}"
RUN steamcmd +force_install_dir "${WORKDIR}" +login anonymous +app_update 1026340 validate +quit

# Load host-specific files
# COPY config_player.xml .
# COPY serversettings.xml .
# COPY clientpermissions.xml .
# COPY start.sh .
# RUN chmod +x start.sh 

ARG LUACS=
RUN if [ -n "${LUACS}" ] ; then \
    wget -q https://github.com/evilfactory/LuaCsForBarotrauma/releases/download/latest/luacsforbarotrauma_patch_linux_server.tar.gz \
    && tar -xzf luacsforbarotrauma_patch_linux_server.tar.gz -C . ; \
fi

RUN mkdir -p "/root/.local/share/Daedalic Entertainment GmbH/Barotrauma" \

CMD ["./mnt/start.sh"]
