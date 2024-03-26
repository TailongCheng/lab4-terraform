terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project                = "${var.var_project}"
}

module "vpc" {
  source                 = "../modules/vpc" 
  env                    = "${var.var_env}"
  lastname                 = "${var.var_lastname}"
  var_vpc_public_subnet  = "${var.vpc_public_subnet}"
  var_vpc_private_subnet = "${var.vpc_private_subnet}"
}

module "compute" {
  source                 = "../modules/compute"
  network_self_link      = "${module.vpc.out_vpc_self_link}"
  subnetwork1            = "${module.uc1.uc1_out_public_subnet_name}"
  env                    = "${var.var_env}"
  var_vpc_public_subnet  = "${var.vpc_public_subnet}"
  var_vpc_private_subnet = "${var.vpc_private_subnet}"
}

module "firewall" {
  source                 = "../modules/firewall"
  network_self_link      = "${module.vpc.out_vpc_self_link}"
  subnetwork1            = "${module.ue1.ue1_out_public_subnet_name}"
  env                    = "${var.var_env}"
  var_vpc_public_subnet  = "${var.vpc_public_subnet}"
  var_vpc_private_subnet = "${var.vpc_private_subnet}"
}

######################################################################
# Display Output Public Instance
######################################################################
output "vpc_public_address"  { value = "${module.vpc.vpc_pub_address}"}
output "vpc_private_address" { value = "${module.vpc.vpc_pri_address}"}
output "vpc_self_link" { value = "${module.vpc.out_vpc_self_link}"}