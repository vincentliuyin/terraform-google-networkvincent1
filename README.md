# terraform-vpc-vincent

A Terraform module to create a VPC network on GCP with subnets, secondary ranges, and routes.

## Usage

```hcl
module "vpc_vincent" {
  source  = "path-to-your-module"
  project = "your-project-id"
  region  = "your-region"
  vpc_name = "your-vpc-name"
}
