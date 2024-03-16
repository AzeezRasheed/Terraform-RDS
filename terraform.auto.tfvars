
# instance_availability_zone = ["us-east-1a", "us-east-1b", "us-east-1c"]
azs = ["us-east-1a", "us-east-1b", "us-east-1c"]

publicly_accessible = false
multi_az            = true
apply_immediately   = false
storage_encrypted   = true

# vpc_name = "ez-us-east-1-dev-vpc"
# subnet_name       = ""
database_name     = "Aurora_PostgreSQL"
database_user     = "testing_postgresql"
database_password = "admin123"
database_port     = 3306

# subnets                  = ["subnet-01a49bc9aa7634750", "subnet-0253f24f45b25fe4a"]
# vpc_id                   = "vpc-0f52b5c60c1c34d27"

name                     = "postgres"
stage                    = "dev"
autoscaling_min_capacity = 2
autoscaling_max_capacity = 4
cluster_family           = "aurora-postgresql14"
engine                   = "aurora-postgresql"
cluster_size             = 2
instance_type            = "db.r5.large"

retention_period             = 7
performance_insights_enabled = true

rds_security_group_name = "eks-cluster-sg-cluster-872092154"
