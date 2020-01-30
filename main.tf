// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("test.json")}"
  project     = "able-yew-254816"
  region      = "us-west1"
}

resource "google_compute_instance" "default" {
  name         = "cm"
  machine_type = "f1-micro"
  //machine_type = "n1-standard-1"
  zone = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  }

  // Make sure flask is installed on all new instances for later steps
  //metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"
  metadata = {
    ssh-keys = "mif:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = "${file("startup.sh")}"

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  # provisioner "local-exec" {
  #   command = "sed -i.bak 's/master_ip/${network_interface.0.network_ip}/g' config.ini my.cnf"
  # }

  provisioner "file" {
    source      = "files"
    destination = "/tmp/files"

    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "mif"
      private_key = "${file("~/.ssh/id_rsa")}"
      agent       = false
    }
  }

  provisioner "remote-exec" {
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "mif"
      private_key = "${file("~/.ssh/id_rsa")}"
      agent       = false
    }
    inline = [
      "cd /tmp/files",
      "sudo apt-get update",
      "sudo apt install libaio1 libmecab2",
      "sed -i.bak 's/master_ip/${self.network_interface.0.network_ip}/g' config.ini my.cnf",
      "cd ..",
      "wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.0/mysql-cluster_8.0.19-1ubuntu18.04_amd64.deb-bundle.tar",
      "mkdir install",
      "tar -xvf mysql-cluster_8.0.19-1ubuntu18.04_amd64.deb-bundle.tar -C install/",
      "cd install",
      "sudo dpkg -i mysql-cluster-community-management-server_8.0.19-1ubuntu18.04_amd64.deb",
      "sudo mkdir /var/lib/mysql-cluster",
      "sudo cp /tmp/files/config.ini /var/lib/mysql-cluster/config.ini",
      "sudo cp /tmp/files/ndb_mgmd.service /etc/systemd/system/ndb_mgmd.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable ndb_mgmd",
      "sudo systemctl start ndb_mgmd",
      "sudo dpkg -i mysql-common_8.0.19-1ubuntu18.04_amd64.deb",
      "sudo dpkg -i mysql-cluster-community-client-core_8.0.19-1ubuntu18.04_amd64.deb",
      "sudo dpkg -i mysql-cluster-community-client_8.0.19-1ubuntu18.04_amd64.deb",
      "sudo dpkg -i mysql-client_8.0.19-1ubuntu18.04_amd64.deb",
      "sudo dpkg -i mysql-cluster-community-server-core_8.0.19-1ubuntu18.04_amd64.deb",
      "echo 'mysql-cluster-community-server mysql-cluster-community-server/root-pass password mypassword'|sudo debconf-set-selections",
      "echo 'mysql-cluster-community-server mysql-cluster-community-server/re-root-pass password mypassword'|sudo debconf-set-selections",
      //"sudo debconf-set-selections <<< \\\"mysql-cluster-community-server mysql-server/default-auth-override      select  Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)\\\"",
      "sudo DEBIAN_FRONTEND=noninteractive dpkg -i mysql-cluster-community-server_8.0.19-1ubuntu18.04_amd64.deb",
      "sudo dpkg -i mysql-server_8.0.19-1ubuntu18.04_amd64.deb",
      "sudo cp /tmp/files/my.cnf /etc/mysql/my.cnf",
      "sudo systemctl restart mysql",
      "sudo systemctl enable mysql",
      //      "consul join ${aws_instance.web.private_ip}",
    ]
  }


}


# sudo apt-get update &&
# #wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.0/mysql-cluster-community-management-server_8.0.19-1ubuntu18.04_amd64.deb
# #sudo dpkg -i mysql-cluster-community-management-server_8.0.19-1ubuntu18.04_amd64.deb
# sudo mkdir /var/lib/mysql-cluster
# wget https://dev.mysql.com/get/Downloads/MySQL-Cluster-8.0/mysql-cluster_8.0.19-1ubuntu18.04_amd64.deb-bundle.tar
# mkdir install
# tar -xvf mysql-cluster_8.0.19-1ubuntu18.04_amd64.deb-bundle.tar -C install/
# cd install
# #sudo apt update
# sudo apt install libaio1 libmecab2
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



# resource "google_compute_firewall" "default" {
#   name    = "elk"
#   network = "default"

#   allow {
#     protocol = "tcp"
#     ports    = ["5601", "5044"]
#   }
# }
