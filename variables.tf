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
