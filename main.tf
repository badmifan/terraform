// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("test.json")}"
  project     = "able-yew-254816"
  region      = "us-west1"
}

resource "google_compute_instance" "default" {
  name = "elk"
  //machine_type = "f1-micro"
  machine_type = "n1-standard-1"
  zone         = "us-west1-a"

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

  provisioner "file" {
    source      = "demo.conf"
    destination = "/tmp/demo.conf"

    connection {
      type        = "ssh"
      user        = "mif"
      private_key = "${file("~/.ssh/id_rsa")}"
      agent       = false
    }
  }
}

resource "google_compute_firewall" "default" {
  name    = "elk"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5601", "5044"]
  }
}
