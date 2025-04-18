resource "aws_security_group" "k8s-sg" {
  name        = "k8s-sg"
  description = "Security group for Kubernetes cluster"
  vpc_id      = module.vpc.vpc_id # Make sure 'module.vpc.vpc_id' is defined

  tags = {
    Name        = "k8s-sg"
    Environment = "dev"
    Project     = "k8s"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_myIP" {
  security_group_id = aws_security_group.k8s-sg.id
  cidr_ipv4         = "192.168.56.4/24"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.k8s-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_icmp" {
  security_group_id = aws_security_group.k8s-sg.id
  ip_protocol       = "icmp"
  from_port         = -1                # All ICMP types
  to_port           = -1                # All ICMP codes
  cidr_ipv4         = "192.168.56.4/24" # Restrict to your VPC (recommended)
}


resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_traffic_ipv4" {
  security_group_id = aws_security_group.k8s-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.k8s-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}