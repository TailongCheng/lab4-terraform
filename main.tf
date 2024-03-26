## Version and configuration
## -------------------------
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.22.0"
    }
  }
}

provider "google" {
  credentials             = file("/home/tailong_cheng/.config/gcloud/application_default_credentials.json")
  project                 = "assignment2-418411"
  region                  = "us-central1"
}

## VPC
## -------------------------
resource "google_compute_network" "vpc-network" {
  project                 = "assignment2-418411"
  name                    = "cheng-network"
  auto_create_subnetworks = "false"
  # routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "public-subnet" {
  project                 = "assignment2-418411"
  name                    = "cheng-pub-subnet"
  ip_cidr_range           = "10.0.10.0/24"
  network                 = google_compute_network.vpc_network.id
  region                  = "us-central1"
}

resource "google_compute_subnetwork" "private-subnet" {
  project                 = "assignment2-418411"
  name                    = "cheng-pri-subnet"
  ip_cidr_range           = "10.0.20.0/24"
  network                 = google_compute_network.vpc_network.id
  region                  = "us-central1"
}

## Firewall Rule
## -------------------------
resource "google_compute_firewall" "container-firewall" {
  name                    = "container-firewall"
  network                 = google_compute_network.vpc_network.name

  # Allow ICMP
  allow {
    protocol              = "icmp"
    priority              = 65534
    description           = "Allow ICMP."
    source_ranges      = ["0.0.0.0/0"]
  }

  # Allow TCP port 8080 web traffic
  allow {
    protocol              = "tcp"
    ports                 = ["8080"]
    priority              = 110
    description           = "Allow HTTP Port 8080 traffic for web servers."
    source_ranges         = ["0.0.0.0/0"]
  }

  # Allow SSH
  allow {
    protocol              = "tcp"
    ports                 = ["22"]
    priority              = 110
    description           = "Allow SSH access from trusted IP addresses."
    source_ranges         = ["0.0.0.0/0"] #Should change to my IP only.
  }

  # Source tags
  source_tags = ["web"]
}

resource "google_compute_firewall" "allow-internal" {
  name                    = "allow-internal"
  network                 = google_compute_network.vpc_network.name
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
    "public-subnet",
    "private-subnet"
  ]
}

## Container Compute VM
## -------------------------
resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "default" {
  name                    = "vm_container"
  machine_type            = "e2-micro"
  zone                    = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-12-bookworm-v20240312"
    }
  }

  network_interface {
    network = "google_compute_network.vpc_network.name"
    subnetwork = "google_compute_subnetwork.public_subnet.name}"
    access_config {
      // Ephemeral public IP
    }
  }
  
  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = 764950655405-compute@developer.gserviceaccount.com
    scopes = ["cloud-platform"]
  }
}

## Below for modulization attempt

# module "vpc" {
#   source                 = "../modules/vpc" 
#   env                    = "${var.env}"
#   public_subnet          = "${var.public_subnet}"
#   private_subnet         = "${var.private_subnet}"
# }


# module "compute" {
#   source                 = "../modules/compute"
#   network_self_link      = "${module.vpc.out_vpc_self_link}"
#   env                    = "${var.var_env}"
# }

# module "firewall" {
#   source                 = "../modules/firewall"
#   network_self_link      = "${module.vpc.out_vpc_self_link}"
#   env                    = "${var.var_env}"
# }

######################################################################
# Display Output Public Instance
######################################################################
# output "vpc_public_address"  { value = "${module.vpc.vpc_pub_address}"}
# output "vpc_private_address" { value = "${module.vpc.vpc_pri_address}"}
# output "vpc_self_link" { value = "${module.vpc.out_vpc_self_link}"}
