sudo apt-get install -y aria2
sudo mkdir /etc/aria2
sudo bash -c "cat <<EOT > /etc/aria2/aria2.conf
enable-rpc=true
rpc-listen-all=true
check-certificate=false
auto-file-renaming=true
dir=/var/run/usbmount/Media/Downloads/
rpc-user=aria2
rpc-passwd=aria2
file-allocation=none
disable-ipv6=true
max-download-limit=1500K
max-overall-download-limit=1500K
log=/var/log/aria2.log
log-level=warn
auto-save-interval=30
EOT"

sudo bash -c "cat <<EOT > /etc/init/aria2.conf
# aria2 - service job file

description \"aria2\"
author \"http://aria2.sourceforge.net/\"

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
        aria2c --conf-path=/etc/aria2/aria2.conf
end script

EOT"

sudo service aria2 start
sudo apt-get install -y nginx
mkdir /tmp/webui
wget -P /tmp/webui/ https://github.com/ziahamza/webui-aria2/archive/master.zip
unzip /tmp/webui/master.zip -d /tmp/webui/
sudo mv /tmp/webui/webui-aria2-master /usr/share/nginx/html/aria2
rm -rf /tmp/webui