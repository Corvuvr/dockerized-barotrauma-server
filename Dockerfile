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


ARG WORKDIR="/BarotraumaDedicatedServer"
ARG MODDIR="/root/.local/share/Daedalic Entertainment GmbH/Barotrauma/WorkshopMods/Installed"
WORKDIR "${WORKDIR}"
RUN steamcmd +force_install_dir "${WORKDIR}" +login anonymous +app_update 1026340 validate +quit

COPY Installed "${MODDIR}"

COPY config_player.xml .
COPY serversettings.xml .
COPY clientpermissions.xml .
COPY start.sh .

RUN chmod +x start.sh 
RUN sed -E -i "s|(path=\")[^\"]*/Installed/|\1${MODDIR}/|g" config_player.xml

RUN wget -q https://github.com/evilfactory/LuaCsForBarotrauma/releases/download/latest/luacsforbarotrauma_patch_linux_server.tar.gz
RUN tar -xzf luacsforbarotrauma_patch_linux_server.tar.gz -C .


CMD ["./start.sh"]
