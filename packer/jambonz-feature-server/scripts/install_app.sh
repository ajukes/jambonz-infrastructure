#!/bin/bash
VERSION=$1

cd /home/admin
mkdir apps credentials
cp /tmp/ecosystem.config.js apps
cd apps

git clone https://github.com/jambonz/jambonz-feature-server.git -b ${VERSION}

cd /home/admin/apps/jambonz-feature-server && npm install

sudo -u admin bash -c "pm2 install pm2-logrotate"
sudo -u admin bash -c "pm2 set pm2-logrotate:max_size 1G"
sudo -u admin bash -c "pm2 set pm2-logrotate:retain 5"
sudo -u admin bash -c "pm2 set pm2-logrotate:compress true"

# add entries to /etc/crontab to start the app on reboot
echo "@reboot admin /usr/bin/pm2 start /home/admin/apps/ecosystem.config.js" | sudo tee -a /etc/crontab
