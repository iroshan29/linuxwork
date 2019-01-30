#!/bin/sh
#
#    00-header - create the header of the MOTD
#    Copyright (c) 2013 Nick Charlton
#    Copyright (c) 2009-2010 Canonical Ltd.
#
#    Based on work of : Nick Charlton <hello@nickcharlton.net>
#             Dustin Kirkland <kirkland@canonical.com>
#

if ! type figlet >/dev/null 2>/dev/null
then
        if [ "$(whoami)" != "root" ]
        then
                echo ==================================================
                echo === Missing required command 'figlet', you need root privileges to continue
                echo ==================================================
                exit 1
        fi
        echo ==================================================
        echo === Installing required command 'figlet'
        echo ==================================================
        yum -y install epel-release
        yum -y install figlet
fi

[ -r /etc/lsb-release ] && . /etc/lsb-release

if [ -z "$DISTRIB_DESCRIPTION" ] && [ -x /usr/bin/lsb_release ]; then
        # Fall back to using the very slow lsb_release utility
        DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi

cat << EOF
########################################################################
# UNAUTHORIZED ACCESS TO THIS SERVER IS PROHIBITED
#
# You must have explicit, authorized permission to
# access or configure this server.
#
# Unauthorized attempts and actions to access or use this system
# may result in civil and/or criminal penalties.
#
# All activities performed on this device are logged and monitored.
#
########################################################################
EOF

if [ -f /home/centos/test/environment.id ]; then
        #Print environment id or machine name id the first is missing
        a=$(cat /home/centos/test/environment.id)
        h=$(hostname)
        figlet -f big ${a:-$h}
else
cat << EOF1
########################################################################
#
# !!!!!! ERROR !!!!!!! THIS INSTANCE HAS NO ID
#
# EDIT THE FILE
#                /home/centos/test/environment.id
#
# AND RUN
#                 /home/centos/test/scripts/updateBanner.sh
#
########################################################################
EOF1

fi

printf "\n"

printf "Welcome to %s (%s).\n" "$DISTRIB_DESCRIPTION" "$(uname -r)"
printf "\n"

[ -f /etc/motd.tail ] && cat /etc/motd.tail || true
