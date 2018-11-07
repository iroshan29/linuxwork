#!/bin/bash
RED="\e[1;31m"
GREEN="\e[1;32m"
WHITE="\e[1;37m"
NC="\e[0m" # No Color
ABSOLUTE_PATH="$(cd "$(dirname "$0")"; pwd)"


host=$1
portset=$2
if [ -z "$host" ] || [ -z "$portset" ] || [ ! -f ${ABSOLUTE_PATH}/"$2".ports ]
then
        echo
        echo -e ${RED} ERROR, YOU MUST SPECIFY AN HOST${NC}
        echo
        echo Usage: $0 "<ip>" portset
        echo
        echo e.g. $0 10.20.3.4 application
        echo
        echo available portsets: $(cd "$ABSOLUTE_PATH"; ls *.ports | cut -d . -f 1)
        echo

        exit 1
fi

ERR=0

echo
echo =====================================================================
echo -e == Checking ports on host ${WHITE}$host${NC}


for port in $(< ${ABSOLUTE_PATH}/${portset}.ports )
do
    echo -ne "${NC}testing port ${WHITE}$port${NC} "
    #(echo > /dev/tcp/$host/$port) &>/dev/null
    nc -zv "$host" "$port" >/dev/null 2>/dev/null
    if [ $? -eq 0 ]
    then
        echo -e ${GREEN}open${NC}
    else
        ERR=1
        echo -e ${RED}CLOSED${NC}
    fi
done
echo =====================================================================

if [ $ERR -gt 0 ]
then
        echo -e ${RED} ERROR, SOME PORTS ARE NOT OPEN${NC}
else
        echo -e ${GREEN} TEST SUCCESFUL${NC}
fi
echo =====================================================================
