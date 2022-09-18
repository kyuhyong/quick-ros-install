#! /bin/bash

# Copyright (c) 2021 Kyuhyong You

# This script will export MASTER URI and HOST IP for ROS
# Input argument 1: MASTER IP
# Input argument 2: PORT number
# HOST IP is automatically setup from ifconfig
# If MASTER IP is not supplied HOST_IP will be assigned

MASTER_IP_SUPPLIED=true
IP_MASTER='localhost'
ROS_PORT='11311'

echo "Configuring MASTER URI and HOSTNAME for ROS"
# Try to get this machine's IP
IP_HOST="$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' | grep -v '172.17')"
if [[ -z $IP_HOST ]] ;
then
    echo "No connection. Falling back to localhost."
    IP_MASTER='localhost'
    IP_HOST="127.0.0.1"
fi
echo "---------------------------------------------------"
printf "\rHOST IP: %23s\n" $IP_HOST
# Check if MASTER IP is supplied
if [ $# -eq 0 ]
    then
        MASTER_IP_SUPPLIED=false
        IP_MASTER=$IP_HOST
        echo "MASTER URI : $IP_MASTER"
    else
        IP_ARG=${1:-1.2.3.4}
        if [[ "$IP_ARG" =~ ^(([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))\.){3}([1-9]?[0-9]|1[0-9][0-9]|2([0-4][0-9]|5[0-5]))$ ]]; then
            IP_MASTER=$IP_ARG
            echo "MASTER IP : $IP_MASTER"
        else
            echo "Wrong IP address"
            exit 1
        fi
fi

# Check for port setting
if [[ "$#" -eq 2 ]]; then
    re='^[0-9]+$'
    if ! [[ $2 =~ $re ]] ; then
        echo "Error: Port number you entered is Not a number" >&2; exit 1
    fi
    ROS_PORT=$2
    printf "\rUse port: %10s\n" $ROS_PORT
else 
    printf "\rUse default port: %15s\n" $ROS_PORT
fi
#echo "PORT : $ROS_PORT"
echo "Finally Set"

HEADER_MASTER_URI="export ROS_MASTER_URI=http://"
HEADER_HOSTNAME="export ROS_HOSTNAME="

MASTER_URI="$IP_MASTER:$ROS_PORT"
HOST_NAME="$IP_HOST"

echo "$HEADER_MASTER_URI$MASTER_URI"
echo "$HEADER_HOSTNAME$HOST_NAME"

#setup ROS environment variables
export ROS_MASTER_URI="http://$MASTER_URI"
export ROS_HOSTNAME="${HOST_NAME}"

input="$HOME/.bashrc"
# REMOVE any line begin with 'export ROS_'
sed -i '/^export ROS_/d' "$input"
echo "$HEADER_MASTER_URI$MASTER_URI" >> "$input"
echo "$HEADER_HOSTNAME$HOST_NAME" >> "$input"
echo "---------------------------------------"
echo "MASTER URI & HOSTNAME Successfully setup in ~/.bashrc"
echo "To apply, please enter source ~/.bashrc"