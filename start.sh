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
if [ ! -d "/config/db" ]; then
   sudo  -u hyperion /usr/bin/hyperiond/bin/hyperiond -i --userdata /config --importConfig initialconfig.json
fi
if test -f "initialconfig.json"; then
   rm initialconfig.json
fi

sudo -u hyperion /usr/bin/hyperiond/bin/hyperiond -i --userdata /config