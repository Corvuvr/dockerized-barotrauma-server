# Dockerized Barotrauma Server

## Preparations
1. Host server locally to generate all necessary files.
    -  **WARNING**: If you are using LuaCs for Barotrauma, temporarily remove it from your active modpack for the time of step 2. Docker will apply working LuaCs patch during the build stage.
2. Download the repo, open it, then copy and replace the following files with the ones from your game directory:
    - `serversettings.xml`
    - `config_player.xml`
3. [Configure](https://barotraumagame.com/wiki/Clientpermissions.xml) `clientpermissions.xml`

## Build
You can enable LuaCS at build stage:
```bash
docker build --rm --build-arg LUACS=true -t barotrauma-server .
```
If you don't need LuaCs, just run this instead:
```bash
docker build --rm -t barotrauma-server .
```

## Run
Locate the folder that holds Barotrauma saves/mods/etc. Accourding to the [server's source code](https://github.com/FakeFishGames/Barotrauma/blob/2cfa1e6ffda87046c1bf735f36871d2755f413b5/Barotrauma/BarotraumaShared/SharedSource/Utils/SaveUtil.cs#L84), it is:
1. `/home/$USER/.local/share/Daedalic Entertainment GmbH/Barotrauma` for Linux
2. `C:\\Users\\*user*\\AppData\\Local\\Daedalic Entertainment GmbH\\Barotrauma` for Windows
3. `/Users/*user*/Library/Application Support/Daedalic Entertainment GmbH/Barotrauma` for MacOS
Now copy its' contents here, in the `Barotrauma/` folder.

Run the docker container with variables specific to your server and mounted $PWD. Refer to [docker-run.def.sh](docker-run.def.sh) for a fresh template:
```bash
docker run \
    --rm -it \
    --net=host \
    -e SERVERNAME=MyServer \
    -e PASSWORD=42 \
    -e PUBLIC= \
    -e PORT= \
    -e QUERYPORT= \
    -e OWNERNAME=CoolGuy1337 \
    -e OWNERID=STEAM_1:0:123456789 \
    -e MAXPLAYERS=10 \
    -v $PWD:/BarotraumaDedicatedServer/mnt \
    barotrauma-server # /bin/bash
```
- Note that the `OWNERNAME` that is used is actually `STEAM_ID2` that you can discover on websites like [steamid.xyz](https://steamid.xyz), but prefixed with `STEAM_1` instead of `STEAM_0`, idk why is so - permissions are assigned that way.

If everything works, you should be able to connect to the server via ip printed to the console. Note that this readme does not cover port forwarding, therefore you shold do this step yourself if needed.

## Helpful links
- [Hosting a dedicated server](https://barotraumagame.com/wiki/Hosting_a_Dedicated_Server).
- [Adjusting serversettings.xml](https://barotraumagame.com/wiki/Serversettings.xml)
