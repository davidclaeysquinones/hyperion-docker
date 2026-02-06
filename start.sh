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
chown -R hyperion:hyperion /config
sudo -u hyperion /usr/bin/hyperiond/bin/hyperiond -i --userdata /config