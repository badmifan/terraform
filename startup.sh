#!/bin/bash -x
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

#cd /tmp
#sudo apt-get update
#sudo apt install libaio1 libmecab2
#wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.0/mysql-cluster-community-management-server_8.0.19-1ubuntu18.04_amd64.deb
#sudo dpkg -i mysql-cluster-community-management-server_8.0.19-1ubuntu18.04_amd64.deb
#
#sudo dpkg -i mysql-common_8.0.19-1ubuntu18.04_amd64.deb
#sudo dpkg -i mysql-cluster-community-client-core_8.0.19-1ubuntu18.04_amd64.deb
#sudo dpkg -i mysql-cluster-community-client_8.0.19-1ubuntu18.04_amd64.deb 
#sudo dpkg -i mysql-client_8.0.19-1ubuntu18.04_amd64.deb 
#sudo dpkg -i mysql-cluster-community-server-core_8.0.19-1ubuntu18.04_amd64.deb

#sudo debconf-set-selections <<< "mysql-cluster-community-server mysql-cluster-community-server/root-pass password mypassword"
#sudo debconf-set-selections <<< "mysql-cluster-community-server mysql-cluster-community-server/re-root-pass password mypassword"
#sudo debconf-set-selections <<< "mysql-cluster-community-server mysql-server/default-auth-override      select  Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)"

#sudo DEBIAN_FRONTEND=noninteractive dpkg -i mysql-cluster-community-server_8.0.19-1ubuntu18.04_amd64.deb
#sudo dpkg -i mysql-server_8.0.19-1ubuntu18.04_amd64.deb 
# sudo cp /tmp/files/config.ini /var/lib/mysql-cluster/config.ini
# sudo cp /tmp/files/ndb_mgmd.service /etc/systemd/system/ndb_mgmd.service
# sudo systemctl daemon-reload
# sudo systemctl enable ndb_mgmd
# sudo systemctl start ndb_mgmd
# sudo systemctl status ndb_mgmd
