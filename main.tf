module "resource_naming" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  enabled     = var.enabled
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  name        = var.name
  attributes  = var.attributes

  tags = local.tags
}



module "subnets" {
  // https://registry.terraform.io/modules/cloudposse/dynamic-subnets/aws/latest
  // https://github.com/cloudposse/terraform-aws-dynamic-subnets
  source  = "cloudposse/dynamic-subnets/aws"
  version = "2.4.1"

  availability_zones          = var.azs
  vpc_id                      = local.baas_dev_vpc_us.vpc_id
  igw_id                      = [local.baas_dev_vpc_us.igw_id]
  ipv4_cidr_block             = [local.ipv4_cidr_block]
  max_subnet_count            = length(var.azs)
  private_route_table_enabled = false
  public_subnets_enabled      = false
  nat_gateway_enabled         = false
  nat_instance_enabled        = false

  context = module.resource_naming.context
}


data "aws_security_group" "rds_security_group" {
  tags = {
    Name = var.rds_security_group_name
    # Add more tags if needed
  }
}


module "rds_cluster_aurora_postgres" {
  source = "cloudposse/rds-cluster/aws"

  subnets = module.subnets.private_subnet_ids

  name                         = var.name
  engine                       = var.engine
  cluster_family               = var.cluster_family
  cluster_size                 = var.cluster_size
  namespace                    = var.namespace
  stage                        = var.stage
  admin_user                   = var.database_user
  admin_password               = var.database_password
  db_name                      = var.database_name
  db_port                      = var.database_port
  instance_type                = var.instance_type
  vpc_id                       = local.baas_dev_vpc_us.vpc_id
  security_groups              = [data.aws_security_group.rds_security_group.id]
  zone_id                      = var.zone_id
  autoscaling_min_capacity     = var.autoscaling_min_capacity
  autoscaling_max_capacity     = var.autoscaling_max_capacity
  storage_encrypted            = true
  publicly_accessible          = false
  retention_period             = var.retention_period
  performance_insights_enabled = var.performance_insights_enabled
}
