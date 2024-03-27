resource "google_compute_network" "vpc_network" {
  project                 = "assignment2-418411"
  name                    = "cheng_network"
  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "public_subnet" {
  name          =  "${format("%s","${var.lastname}-${var.env}-${var.region_map["${var.var_region_name}"]}-pub-net")}"
  ip_cidr_range = "${var.var_vpc_public_subnet}"
  network       = "${var.network_self_link}"
  region        = "${var.region}"
}

resource "google_compute_subnetwork" "private_subnet" {
  name          =  "${format("%s","${var.lastname}-${var.env}-${var.region_map["${var.var_region_name}"]}-pri-net")}"
  ip_cidr_range = "${var.var_vpc_private_subnet}"
  network      = "${var.network_self_link}"
  region        = "${var.var_region_name}"
}