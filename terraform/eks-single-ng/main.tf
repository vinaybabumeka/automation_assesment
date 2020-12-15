provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

module "myvpc" {
  source       = "../modules/vpc"
  cluster_name = "demo-cluster"
  vpc_cidr     = "10.0.0.0/16"
  vpc_dns_hostnames = "true"
  public_subnets = {
    us-east-1a = "10.0.1.0/24"
    us-east-1b = "10.0.2.0/24"
    us-east-1c = "10.0.3.0/24"
  }
  private_subnets = {
    us-east-1a = "10.0.4.0/24"
    us-east-1b = "10.0.5.0/24"
    us-east-1c = "10.0.6.0/24"
  }
}
