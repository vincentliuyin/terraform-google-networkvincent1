provider "google" {
  project = var.project
  region  = var.region
}

locals {
  subnets = [for i in range(var.subnet_count) : {
    subnet_name           = "${var.vpc_name}-subnet-${format("%02d", i + 1)}"
    subnet_ip             = cidrsubnet(var.base_cidr_block, var.subnet_prefix_length - length(split("/", var.base_cidr_block)[1]), i)
    subnet_region         = var.region
    subnet_private_access = true
    subnet_flow_logs      = true
    description           = "Automatically generated subnet"
  }]
}

module "vpc-vincent" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.1"

  project_id   = var.project
  network_name = var.vpc_name
  routing_mode = "GLOBAL"

  subnets = local.subnets

  secondary_ranges = {
    for subnet in local.subnets : subnet.subnet_name => []
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
