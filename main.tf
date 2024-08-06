provider "google" {
  project = var.project
  region  = var.region
}

locals {
  vpc_cidr_block = cidrsubnet(var.base_cidr_block, 4, var.vpc_index)

  subnet_01_name = "${var.vpc_name}-subnet-01"
  subnet_02_name = "${var.vpc_name}-subnet-02"
  subnet_03_name = "${var.vpc_name}-subnet-03"

  subnet_01_cidr = cidrsubnet(local.vpc_cidr_block, 8, 1)
  subnet_02_cidr = cidrsubnet(local.vpc_cidr_block, 8, 2)
  subnet_03_cidr = cidrsubnet(local.vpc_cidr_block, 8, 3)
}

module "vpc-vincent" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.1"

  project_id   = var.project
  network_name = var.vpc_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = local.subnet_01_name
      subnet_ip             = local.subnet_01_cidr
      subnet_region         = var.region
    },
    {
      subnet_name           = local.subnet_02_name
      subnet_ip             = local.subnet_02_cidr
      subnet_region         = var.region
      subnet_private_access = true
      subnet_flow_logs      = true
      description           = "This subnet has a description"
    },
    {
      subnet_name               = local.subnet_03_name
      subnet_ip                 = local.subnet_03_cidr
      subnet_region             = var.region
      subnet_flow_logs          = true
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
  ]

  secondary_ranges = {
    (local.subnet_01_name) = [
      {
        range_name    = "subnet-01-secondary-01"
        ip_cidr_range = "192.168.64.0/24"
      },
    ]

    (local.subnet_02_name) = []
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
