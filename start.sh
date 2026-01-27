#!/bin/bash

# Loop through arguments
for arg in "$@"; do
   case "$arg" in
      uid=*) uid="${arg#*=}" ;;
      gid=*) gid="${arg#*=}" ;;
   esac
done


groupmod -g $gid hyperion
usermod -u $uid hyperion
ln -s /root/.hyperion /config 
chown -R hyperion:hyperion /config
sudo -u hyperion /usr/bin/hyperiond -v --service --userdata /config
hyperiond -i