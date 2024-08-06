provider "google" {
  project = var.project
  region  = var.region
}

resource "random_integer" "subnet_suffix" {
  min = 1
  max = 200
}

locals {
  subnet_name = "${var.vpc_name}-subnet-01"
  subnet_cidr = cidrsubnet("10.0.0.0/16", 8, random_integer.subnet_suffix.result)
}

module "vpc-vincent" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.1"

  project_id   = var.project
  network_name = var.vpc_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = local.subnet_name
      subnet_ip             = local.subnet_cidr
      subnet_region         = var.region
    }
  ]

  secondary_ranges = {
    (local.subnet_name) = []
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "Route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = true
    }
  ]
}
