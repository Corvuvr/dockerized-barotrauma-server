#!/bin/bash

MNT="$(realpath "$(dirname "$0")")"
echo "MNT is: $MNT"

if [[ ! -f "$MNT/serversettings.xml" ]]; then
    cp --preserve "$MNT/serversettings.def.xml" "$MNT/serversettings.xml"
fi
ln -sf "$MNT/serversettings.xml" "$PWD/serversettings.xml"


if [[ ! -f "$MNT/clientpermissions.xml" ]]; then
    cp --preserve "$MNT/clientpermissions.def.xml" "$MNT/clientpermissions.xml"
fi
ln -sf "$MNT/clientpermissions.xml" "$PWD/clientpermissions.xml"


if [[ ! -f "$MNT/config_player.xml" ]]; then
    cp --preserve "$MNT/config_player.def.xml" "$MNT/config_player.xml"
fi
ln -sf "$MNT/config_player.xml" "$PWD/config_player.xml"


if [[ ! -d "$MNT/Barotrauma" ]] ; then 
    echo "Path not found: $MNT/Barotrauma"
    exit 2
fi


DAEDALIC="/root/.local/share/Daedalic Entertainment GmbH"
mkdir -p "$DAEDALIC"
ln -sfn "$MNT/Barotrauma" "$DAEDALIC"


echo "Contents of $DAEDALIC:"
ls "$DAEDALIC/" -la
echo "Contents of $DAEDALIC/Barotrauma:"
ls "$DAEDALIC/Barotrauma" -la

MODDIR="$DAEDALIC/Barotrauma/WorkshopMods/Installed"
sed -E -i --follow-symlinks "s|(path=\")[^\"]*/Installed/|\1${MODDIR}/|g" config_player.xml

if [ -n "${SERVERNAME}" ] ; then sed -i --follow-symlinks "s/name=.*/name=\"${SERVERNAME}\"/"             serversettings.xml ; fi
if [ -n "${PASSWORD}" ]   ; then sed -i --follow-symlinks "s/password=.*/password=\"${PASSWORD}\"/"       serversettings.xml ; fi
if [ -n "${PUBLIC}" ]     ; then sed -i --follow-symlinks "s/public=.*/public=\"${PUBLIC}\"/"             serversettings.xml ; fi
if [ -n "${PORT}" ]       ; then sed -i --follow-symlinks "s/port=.*/port=\"${PORT}\"/"                   serversettings.xml ; fi
if [ -n "${QUERYPORT}" ]  ; then sed -i --follow-symlinks "s/queryport=.*/queryport=\"${QUERYPORT}\"/"    serversettings.xml ; fi
if [ -n "${MAXPLAYERS}" ] ; then sed -i --follow-symlinks "s/maxplayers=.*/maxplayers=\"${MAXPLAYERS}\"/" serversettings.xml ; fi
if [ -n "${OWNERNAME}" ]  ; then sed -i --follow-symlinks "s/name=.*/name=\"${OWNERNAME}\"/"              clientpermissions.xml ; fi
if [ -n "${OWNERID}" ]    ; then sed -i --follow-symlinks "s/accountid=\".*\"/accountid=\"${OWNERID}\"/"  clientpermissions.xml ; fi

ip=$(hostname -I)
port=$(grep " port=" serversettings.xml | cut -d'"' -f2)

echo -e "\e[31m"
echo Running server on ${ip::-1}:${port}...
echo -e "\e[0m"

./DedicatedServer
