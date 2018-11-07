#!/bin/bash

if [ "$(whoami)" != "root" ]
then
        echo "This script must be run as root\n\n"
        exit 1
fi

ABSOLUTE_PATH="$(cd "$(dirname "$0")"; pwd)"

bash $ABSOLUTE_PATH/printBanner.sh >/etc/motd
