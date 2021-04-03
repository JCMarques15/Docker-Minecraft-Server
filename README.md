# Docker-Minecraft-Server
This is a simple minecraft server I created to learn and consolidate some docker concepts related to the building of images. 

The entrypoint.sh script takes care of reading environment variables for easier configuration of the server at startup without the need to fiddle with files directly. To safeguard against restarts, a named volume is created at startup that mounts in the container to hold server configuration and save information.

## Starting the server
Configure environment variables as necessary.

Simple single shard (no caves)
```bash
docker run -d --name minecraft \
-e MC_RAM="<Value in MB>" \
-e MC_DISCORD="<Webhook>" \
-e MC_NAME="<Name>" \
-e MC_MOTD="<Message of the day>" \
-e MC_DIFFICULTY="<peaceful|easy|normal|hard>" \
-e MC_HARDCORE="<true|false>" \
-e MC_GAMEMODE="<survival|creative|adventure|spectator>" \
-e MC_PVP="<true|false>" \
-e MC_MAX_PLAYERS="<Num of Players>" \
-v minecraft:/home/LinuxGSM/serverfiles \
jmarques15/minecraft
```