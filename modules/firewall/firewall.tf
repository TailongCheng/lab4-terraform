resource "google_compute_firewall" "allow-internal" {
  name    = "${var.lastname}-fw-allow-internal"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = [
    "${var.var_vpc_private_subnet}",
    "${var.var_vpc_private_subnet}"
  ]
}

resource "google_compute_firewall" "allow-http" {
  name    = "${var.lastname}-fw-allow-http"
  network = "${google_compute_network.vpc.name}"
allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"] 
}

resource "google_compute_firewall" "allow-bastion" {
  name    = "${var.lastname}-fw-allow-bastion"
  network = "${google_compute_network.vpc.name}"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
  }