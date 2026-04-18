# Dockerized Barotrauma Server

## Modded server prerequisites
Install mods on your client and copy them over to the `Installed/` folder like shown in [here](Installed/README.md). 
Then proceed to the next section of this readme.

## Setup
1. Host server locally to generate all necessary files.
2. Download the repo, open it, then copy and replace the following files with the ones from your game directory:
    - `serversettings.xml`
    - `config_player.xml`
3. [Configure](https://barotraumagame.com/wiki/Clientpermissions.xml) `clientpermissions.xml`
4. Build and run: 
```bash
docker build -t barotrauma-server .
# Get `port` and `queryport` from `serversettings.xml`
docker run -it -p<port:port> -p<queryport:queryport> barotrauma-server
```

## Helpful links
- [Hosting a dedicated server](https://barotraumagame.com/wiki/Hosting_a_Dedicated_Server).
- [Adjusting serversettings.xml](https://barotraumagame.com/wiki/Serversettings.xml)
