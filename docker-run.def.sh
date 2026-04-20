docker run --rm -it \
    -e SERVERNAME= \
    -e PASSWORD= \
    -e PUBLIC= \
    -e PORT= \
    -e QUERYPORT= \
    -e OWNERNAME= \
    -e OWNERID= \
    -e MAXPLAYERS= \
    -v "/home/$USER/.local/share/Daedalic Entertainment GmbH/Barotrauma":"/root/.local/share/Daedalic Entertainment GmbH/Barotrauma" \
    -v $PWD:/BarotraumaDedicatedServer/mnt:ro \
    -p 27015:27015 \
    -p 27016:27016 \
    barotrauma-server
