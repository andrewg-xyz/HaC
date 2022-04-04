#!/usr/bin/env bash

sudo apt-get install software-properties-common
sudo apt update
sudo apt install openjdk-17-jdk-headless screen -y

sudo mkdir $HOME/minecraft
sudo cp /tmp/server.jar $HOME/minecraft
