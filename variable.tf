
# variable "instance_availability_zone" {
#   description = "List of availability zones for RDS instances"
#   type        = list(string)
# }

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}



variable "database_name" {
  description = "Name of the database"
  type        = string
}

variable "database_user" {
  description = "Username for the database"
  type        = string
}

variable "database_password" {
  description = "Password for the database"
  type        = string
}

variable "rds_security_group_name" {
  description = "Name of Secuity Goup"
  type        = string
}

variable "database_port" {
  description = "Port for the database"
  type        = number
}

variable "additional_routes" {
  default     = []
  description = "A list of additional routes that should be attached to the Client VPN endpoint"

  type = list(object({
    destination_cidr_block = string
    description            = string
    target_vpc_subnet_id   = string
  }))
}

variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
}

variable "engine" {
  description = "Database engine"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the RDS instance"
  type        = string
}

variable "cluster_family" {
  description = "Name of the database cluster family"
  type        = string
}


variable "publicly_accessible" {
  description = "Make the RDS instance publicly accessible"
  type        = bool
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
}

variable "autoscaling_min_capacity" {
  type        = number
  default     = 1
  description = "Minimum number of instances to be maintained by the autoscaler"
}

variable "autoscaling_max_capacity" {
  type        = number
  default     = 5
  description = "Maximum number of instances to be maintained by the autoscaler"
}

variable "zone_id" {
  type        = any
  default     = []
  description = <<-EOT
    Route53 DNS Zone ID as list of string (0 or 1 items). If empty, no custom DNS name will be published.
    If the list contains a single Zone ID, a custom DNS name will be pulished in that zone.
    Can also be a plain string, but that use is DEPRECATED because of Terraform issues.
    EOT
}

variable "cluster_size" {
  type        = number
  default     = 2
  description = "Number of DB instances to create in the cluster"
}
variable "retention_period" {
  type        = number
  default     = 5
  description = "Number of days to retain backups for"
}

variable "performance_insights_enabled" {
  type        = bool
  default     = false
  description = "Whether to enable Performance Insights"
}

