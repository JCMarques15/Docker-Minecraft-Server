#!/bin/bash

# Fuction to handle exit of container
cleanup() {
    ./mcserver stop > /dev/null
    exit 0
}

configure_server () {

    # Configure Server Max RAM
    if [ -v MC_RAM ]
    then
        grep "javaram=" lgsm/config-lgsm/mcserver/mcserver.cfg &&  
        sed -i "s/javaram=\".*\"/javaram=\"$MC_RAM\"/" lgsm/config-lgsm/mcserver/mcserver.cfg || 
        echo "javaram=\"$MC_RAM\"" | tee -a lgsm/config-lgsm/mcserver/mcserver.cfg
    fi

    # Configure Discord Alerting
    if [ -v MC_DISCORD ]
    then
        grep "discordalert=\"on\"" lgsm/config-lgsm/mcserver/mcserver.cfg &&  
        sed -i "s/discordwebhook=\".*\"/discordwebhook=\"$MC_DISCORD\"/" lgsm/config-lgsm/mcserver/mcserver.cfg || 
        echo -e "discordalert=\"on\"\ndiscordwebhook=\"$MC_DISCORD\"\npostalert=\"on\"" | tee -a lgsm/config-lgsm/mcserver/mcserver.cfg
    fi

    # Configure Server Name
    if [ -v MC_NAME ]
    then
        echo "Name: $MC_NAME"
        sed -i "s/level-name=.*/level-name=$MC_NAME/" serverfiles/server.properties
    fi

    # Configure Server MOTD
    if [ -v MC_MOTD ]
    then
        echo "MOTD: $MC_MOTD"
        sed -i "s/motd=.*/motd=$MC_MOTD/" serverfiles/server.properties
    fi

    # Configure Server Difficulty
    if [ -v MC_DIFFICULTY ]
    then
        echo "Difficulty: $MC_DIFFICULTY"
        sed -i "s/difficulty=.*/difficulty=$MC_DIFFICULTY/" serverfiles/server.properties
    fi

    # Configure Server Hardcore
    if [ -v MC_HARDCORE ]
    then
        echo "Hardcore: $MC_HARDCORE"
        sed -i "s/hardcore=.*/hardcore=$MC_HARDCORE/" serverfiles/server.properties
    fi

    # Configure Server Gamemode
    if [ -v MC_GAMEMODE ]
    then
        echo "Difficulty: $MC_GAMEMODE"
        sed -i "s/gamemode=.*/gamemode=$MC_GAMEMODE/" serverfiles/server.properties
    fi

    # Configure Server PvP
    if [ -v MC_PVP ]
    then
        echo "PvP: $MC_PVP"
        sed -i "s/pvp=.*/pvp=$MC_PVP/" serverfiles/server.properties
    fi

    # Configure Server Gamemode
    if [ -v MC_MAX_PLAYERS ]
    then
        echo "Max Players: $MC_MAX_PLAYERS"
        sed -i "s/max-players=.*/max-players=$MC_MAX_PLAYERS/" serverfiles/server.properties
    fi

    # Disable GameSpy4
    sed -i "s/enable-query=.*/enable-query=true/" serverfiles/server.properties

    # Force Gamemode
    sed -i "s/force-gamemode=.*/force-gamemode=true/" serverfiles/server.properties

    # Set idle timeout
    sed -i "s/player-idle-timeout=.*/player-idle-timeout=30/" serverfiles/server.properties

    # Disable snooper
    sed -i "s/snooper-enabled=.*/snooper-enabled=false/" serverfiles/server.properties

    # Enable Whitelisting
    sed -i "s/white-list=.*/white-list=true/" serverfiles/server.properties
}

# Trap the SIGTERM signal
trap cleanup SIGTERM

# Call function to configure server:
configure_server

# Start Server
echo -e "Server configured, starting server."
./mcserver start

# Follow console log
tail -F log/console/mcserver-console.log &

# Wait Indefinitly
wait $!