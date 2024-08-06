variable "project" {
  description = "The GCP project ID"
  type        = string
  default     = "sandbox-vincentliu"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "europe-north1"
}

variable "vpc_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "base_cidr_block" {
  description = "The base CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_prefix_length" {
  description = "The prefix length for the subnets"
  type        = number
  default     = 24
}

variable "subnet_count" {
  description = "The number of subnets to create"
  type        = number
  default     = 3
}
