module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "k8s-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway   = false
  enable_vpn_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  public_subnet_tags = {
    "Name"                                 = "k8s-public"
    "kubernetes.io/cluster/k8s.lazaai.xyz" = "shared" # Optional but good for ELB auto-discovery
    "kubernetes.io/role/elb"               = "1"
    "Tier"                                 = "public"
  }

  private_subnet_tags = {
    "Name"                                 = "k8s-private"
    "kubernetes.io/cluster/k8s.lazaai.xyz" = "shared"
    "kubernetes.io/role/internal-elb"      = "1"
    "Tier"                                 = "private"
  }
}

# 🚀 Public Subnet Route Table
resource "aws_route_table" "k8s_route_table" {
  vpc_id = module.vpc.vpc_id

  tags = {
    "kubernetes.io/cluster/k8s.lazaai.xyz" = "shared"
    "Name"                                 = "k8s-route-table"
  }
}