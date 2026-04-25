#!/bin/bash

MNT="$(realpath "$(dirname "$0")")"
cp "$MNT/serversettings.xml" .
cp "$MNT/clientpermissions.xml" .
cp "$MNT/config_player.xml" .

echo "MNT is: $MNT"

if [[ ! -d "$MNT/Barotrauma" ]] ; then 
    echo "Path not found: $MNT/Barotrauma"
    exit 2
fi
DAEDALIC="/root/.local/share/Daedalic Entertainment GmbH"
mkdir -p "$DAEDALIC"
ln -sf "$MNT/Barotrauma" "$DAEDALIC"

echo "Contents of $DAEDALIC:"
ls "$DAEDALIC/" -la
echo "Contents of $DAEDALIC/Barotrauma:"
ls "$DAEDALIC/Barotrauma" -la

MODDIR="$DAEDALIC/Barotrauma/WorkshopMods/Installed"
sed -E -i "s|(path=\")[^\"]*/Installed/|\1${MODDIR}/|g" config_player.xml

if [ -n "${SERVERNAME}" ] ; then sed -i "s/name=.*/name=\"${SERVERNAME}\"/"             serversettings.xml ; fi
if [ -n "${PASSWORD}" ]   ; then sed -i "s/password=.*/password=\"${PASSWORD}\"/"       serversettings.xml ; fi
if [ -n "${PUBLIC}" ]     ; then sed -i "s/public=.*/public=\"${PUBLIC}\"/"             serversettings.xml ; fi
if [ -n "${PORT}" ]       ; then sed -i "s/port=.*/port=\"${PORT}\"/"                   serversettings.xml ; fi
if [ -n "${QUERYPORT}" ]  ; then sed -i "s/queryport=.*/queryport=\"${QUERYPORT}\"/"    serversettings.xml ; fi
if [ -n "${MAXPLAYERS}" ] ; then sed -i "s/maxplayers=.*/maxplayers=\"${MAXPLAYERS}\"/" serversettings.xml ; fi
if [ -n "${OWNERNAME}" ]  ; then sed -i "s/name=.*/name=\"${OWNERNAME}\"/"              clientpermissions.xml ; fi
if [ -n "${OWNERID}" ]    ; then sed -i "s/accountid=\".*\"/accountid=\"${OWNERID}\"/"  clientpermissions.xml ; fi

ip=$(hostname -I)
port=$(grep " port=" serversettings.xml | cut -d'"' -f2)

echo -e "\e[31m"
echo Running server on ${ip::-1}:${port}...
echo -e "\e[0m"

./DedicatedServer
