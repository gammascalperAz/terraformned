#############################################################################
# VARIABLES
#############################################################################

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "vpc_cidr_range" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
  # default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

#############################################################################
# PROVIDERS
#############################################################################

provider "aws" {
  region = var.region
}

#############################################################################
# DATA SOURCES
#############################################################################

data "aws_availability_zones" "azs" {}

#############################################################################
# RESOURCES
#############################################################################  

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = "${terraform.workspace}-vpc"
  cidr = var.vpc_cidr_range

  azs            = slice(data.aws_availability_zones.azs.names, 0, 1)
  public_subnets = var.public_subnets

  tags = {
    Environment = terraform.workspace
    Team        = "ninja"
  }

}

#############################################################################
# OUTPUTS
#############################################################################

output "vpc_id" {
  value = module.vpc.vpc_id
}
