# Dockerized Barotrauma Server

## Modded server prerequisites
Based on official [wiki page](https://barotraumagame.com/wiki/Enabling_Mods_on_a_Dedicated_Server).
1. Install mods on your client and follow the steps in [Installed/README.md](Installed/README.md). 
2. Replace `<contentpackages>` block from `serversettings.xml` with your entries inside `YOUR/BAROTRAUMA/DIRECTORY/config_player.xml`
3. Proceed to the `Setup` section of this readme.

## Setup
1. [Adjust](https://barotraumagame.com/wiki/Serversettings.xml) `serversettings.xml` to your liking.
2. Replace `clientpermissions.xml` with `YOUR/BAROTRAUMA/DIRECTORY/clientpermissions.xml` (if absent, try to host multiplayer server from the game as usual to generate it).
3. Run the following: 
```bash
docker build -t barotrauma-server .
# Get `port` and `queryport` from `serversettings.xml`
docker run -it -p<port:port> -p<queryport:queryport> barotrauma-server
```

- More info [here](https://barotraumagame.com/wiki/Hosting_a_Dedicated_Server).
