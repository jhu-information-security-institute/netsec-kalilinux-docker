#!/bin/bash

if [ ! -d ~/.vnc/ ]; then
    mkdir -p ~/.vnc/
fi
if [ ! -f ~/.Xauthority ]; then
    touch ~/.Xauthority
fi
rm -rf ~/.vnc/*.pid ~/.vnc/*.log /tmp/.X1*
echo -e "${PASSWORD}\n${PASSWORD}" | sudo passwd "${USER}"
sudo service ssh start
sudo chown "${USERNAME}:${USERNAME}" /mnt/dockershared
vncpasswd -f <<< ${PASSWORD} > ~/.vnc/passwd
sudo dbus-daemon --config-file=/usr/share/dbus-1/system.conf
vncserver -PasswordFile ~/.vnc/passwd
/usr/share/novnc/utils/novnc_proxy --listen "${NOVNCPORT}" --vnc "127.0.0.1:${VNCPORT}"
############################################################
#to troubleshoot: comment out the failing instructions above and uncomment command below (just runs indefinitely)
#tail -f /dev/null
############################################################
