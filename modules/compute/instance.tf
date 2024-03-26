resource "google_compute_instance" "default" {
  name         = "${format("%s","${var.lastname}-${var.env}-${var.region_map["${var.var_region_name}"]}-instance1")}"
  machine_type  = "e2-micro"
  #zone         =   "${element(var.var_zones, count.index)}"
  zone          =   "${format("%s","${var.var_region_name}-b")}"
  tags          = ["ssh","http"]
  boot_disk {
    initialize_params {
      image     =  "Debian GNU/Linux 12 (bookworm)"     
    }
  }
labels {
      webserver =  "true"     
    }
network_interface {
    subnetwork = "${google_compute_subnetwork.public_subnet.name}"
    access_config {
      // Ephemeral IP
    }
  }
}