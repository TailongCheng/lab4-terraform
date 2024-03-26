resource "google_compute_instance" "vm_container" {
  name         = "vm_container"
  machine_type  = "e2-micro"
  zone          =   "${format("%s","${var.region}-b")}"
  tags          = ["ssh","http"]

  boot_disk {
    initialize_params {
      image     =  "debian-cloud/debian-12"     
    }
  }

  labels {
      webserver =  "true"     
    }
  
  network_interface {
    network = 
    subnetwork = "${google_compute_subnetwork.public_subnet.name}"
    access_config {
      // Ephemeral IP
    }
  }
}