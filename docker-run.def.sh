docker run \
    --rm -it \
    --net=host \
    -e SERVERNAME= \
    -e PASSWORD= \
    -e PUBLIC= \
    -e PORT= \
    -e QUERYPORT= \
    -e OWNERNAME= \
    -e OWNERID= \
    -e MAXPLAYERS= \
    -v $PWD:/BarotraumaDedicatedServer/mnt \
    barotrauma-server # /bin/bash
