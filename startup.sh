#!/bin/bash -x
sudo apt-get install -y default-jre
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install -y elasticsearch logstash kibana
sudo systemctl daemon-reload 
sudo systemctl enable elasticsearch.service
sudo bash -c 'echo network.host: 127.0.0.1 >> /etc/elasticsearch/elasticsearch.yml' 
sudo systemctl restart elasticsearch.service
sudo systemctl enable logstash.service
sudo systemctl restart logstash.service
sudo bash -c 'echo server.host: 127.0.0.1 >> /etc/kibana/kibana.yml' 
sudo systemctl enable kibana.service
sudo systemctl restart kibana.service

