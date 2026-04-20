docker run -it \
    -e SERVERNAME= \
    -e PASSWORD= \
    -e PUBLIC= \
    -e PORT= \
    -e QUERYPORT= \
    -e OWNERNAME= \
    -e OWNERID= \
    -e MAXPLAYERS= \
    -v $PWD:/BarotraumaDedicatedServer/mnt \
    -p 27015:27015 \
    -p 27016:27016 \
    barotrauma-server
