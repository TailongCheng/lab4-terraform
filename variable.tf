variable "gcp_project" {
        description = "GCP project for assignment 2"
        default = "cheng-assignment2"
}

variable "env" {
        default = "dev"
}

variable "region" {
        default = "us-central1"
}

variable "private_subnet" {
        default = "10.0.20.0/24"
}

variable "public_subnet" {
        default = "10.0.10.0/24"
}