# terraform {
#   required_version = ">= 1.0.0"

#   backend "s3" {
#     region         = "us-east-1"
#     bucket         = "ez-us-east-1-dev-terraform-tfstate-backend"
#     key            = "rds.tfstate"
#     dynamodb_table = "ez-us-east-1-dev-terraform-tfstate-backend-lock"
#     profile        = "baas-dev"
#     role_arn       = ""
#     encrypt        = "true"
#   }
# }

data "terraform_remote_state" "baas_dev_vpc_us" {
  backend = "s3"
  config = {
    bucket  = "ez-us-east-1-dev-terraform-tfstate-backend"
    key     = "vpc.tfstate"
    profile = "baas-dev"
    region  = "us-east-1"
  }
}
