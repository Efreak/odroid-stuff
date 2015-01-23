sudo apt-get install libc6-armel gcc-multilib
mkdir /tmp/plex
wget -P /tmp/plex https://downloads.plex.tv/plex-media-server/0.9.11.7.803-87d0708/plexmediaserver-ros6-binaries_0.9.11.7.803-87d0708_armel.deb
dpkg -x /tmp/plex/plexmediaserver-ros6-binaries_0.9.11.7.803-87d0708_armel.deb /tmp/plex
sudo mv /tmp/plex/apps /
sudo mkdir /apps/plexmediaserver/temp
sudo mkdir /apps/plexmediaserver/MediaLibrary
sudo bash -c "cat <<EOT > /etc/init/plexmediaserver.conf
# plexpms - service job file

description \"Plex Media Server\"
author \"http://www.plexapp.com/\"

# When to start the service
start on runlevel [2345]

# When to stop the service
stop on runlevel [016]

# Automatically restart process if crashed
respawn

# Sets nice and ionice level for job
nice -5

# What to execute
script
        su -c /apps/plexmediaserver/Binaries/start.sh > /var/log/plexms.log 2>&1
end script

EOT"

sudo bash -c "cat <<EOT > /etc/default/plexmediaserver_environment
# default script for Plex Media Server

# the number of plugins that can run at the same time
PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS=6

# ulimit -s \\\$PLEX_MEDIA_SERVER_MAX_STACK_SIZE
PLEX_MEDIA_SERVER_MAX_STACK_SIZE=3000

# uncomment to set it to something else
PLEX_MEDIA_SERVER_APPLICATION_SUPPORT_DIR=\"/apps/plexmediaserver/MediaLibrary\"

# let's set the tmp dir to something useful.
TMPDIR=\"/apps/plexmediaserver/temp\"

# We need to catch our libraries
LD_LIBRARY_PATH=\"/apps/plexmediaserver/Binaries:\\\$LD_LIBRARY_PATH\"

EOT"

sudo bash -c "cat <<EOT > /apps/plexmediaserver/Binaries/start.sh
#!/bin/sh
#SCRIPTPATH=\\\$(dirname \\\$(python -c 'import sys,os;print os.path.realpath(sys.argv[1])' \\\$0))
SCRIPT=\\\$(readlink -f \\\$0)
SCRIPTPATH=\\\`dirname \\\${SCRIPT}\\\`
export LD_LIBRARY_PATH=\"\\\${SCRIPTPATH}\"
export PLEX_MEDIA_SERVER_HOME=\"\\\${SCRIPTPATH}\"
export PLEX_MEDIA_SERVER_MAX_PLUGIN_PROCS=6
export LC_ALL=\"en_US.UTF-8\"
export LANG=\"en_US.UTF-8\"
ulimit -s 3000
cd \\\${SCRIPTPATH}
./Plex\ Media\ Server
EOT"

sudo service plexmediaserver start