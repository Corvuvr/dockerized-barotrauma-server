#!/bin/bash

ip=$(hostname -I)
port=$(grep ' port=' serversettings.xml | cut -d'"' -f2)

echo -e "\e[31m"
echo Running server on ${ip::-1}:${port}...
echo -e "\e[0m"

./DedicatedServer
