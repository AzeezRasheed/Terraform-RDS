### GLOBAL VARS
## ============================================================================
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "profile" {
  type        = string
  default     = "baas-dev"
  description = "Profile name from ~/.aws/config file"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "namespace" {
  type        = string
  default     = "ez"
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  default     = "us-east-1"
  description = "Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT'"
}

variable "stage" {
  type        = string
  default     = "dev"
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  default     = null
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

## ============================================================================
provider "aws" {
  region  = var.region
  profile = var.profile
}

data "aws_caller_identity" "current" {}

locals {
  account_id  = data.aws_caller_identity.current.account_id
  dir_current = basename(path.cwd)

  baas_dev_vpc_us = data.terraform_remote_state.baas_dev_vpc_us.outputs.vpc

  ipv4_cidr_block = cidrsubnet(local.baas_dev_vpc_us.vpc_cidr_block, 5, 27)

  dns_servers = [cidrhost(local.baas_dev_vpc_us.vpc_cidr_block, 2), "1.1.1.1"]

  additional_routes = [for route in var.additional_routes : {
    destination_cidr_block = "10.150.0.0/16"
    description            = "route.description"
    target_vpc_subnet_id   = element(module.subnets.private_subnet_ids, 0)
  }]

  authorization_rules = [
    {
      name                 = "All to local"
      authorize_all_groups = true
      description          = "All to local"
      target_network_cidr  = local.baas_dev_vpc_us.vpc_cidr_block
    },
    {
      name                 = "All to 0.0.0.0/0"
      authorize_all_groups = true
      description          = "All to 0.0.0.0/0"
      target_network_cidr  = "0.0.0.0/0"
    },

  ]
  tags = tomap({
    "Owner"     = tostring(local.account_id),
    "Terraform" = tostring(local.dir_current)
  })
}

