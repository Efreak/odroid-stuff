sudo apt-get install -y aria2
sudo mkdir /etc/aria2
sudo touch /etc/aria2/aria2.session
sudo bash -c "cat <<EOT > /etc/aria2/aria2.conf
daemon=true
continue=true
enable-rpc=true
rpc-listen-port=6800
rpc-listen-all=true
check-certificate=false
auto-file-renaming=false
allow-overwrite=true
dir=/media/shares/Efreak/Downloads
rpc-user=username
rpc-passwd=password
file-allocation=none
max-download-limit=0
max-overall-download-limit=0
max-concurrent-downloads=2
max-connection-per-server=4
log=/var/log/aria2.log
log-level=error
summary-interval=120
timeout=600
retry-wait=30
max-tries=50
save-session=/etc/aria2/aria2.session
input-file=etc/aria2/aria2.session
save-session-interval=10
disk-cache=25M
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
