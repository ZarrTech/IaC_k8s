resource "aws_security_group" "k8s-sg" {
  name        = "k8s-sg"
  description = "k8s-sg"
  tags = {
    Name = "allow_tls"
    Name= "allow_icmp"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_myIP" {
  security_group_id = aws_security_group.k8s-sg.id
  cidr_ipv4         = "0.0.0.0/0"
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

# resource "aws_vpc_security_group_ingress_rule" "allow_icmp" {
#   security_group_id = aws_security_group.k8s-sg.id
#   ip_protocol       = "icmp"
#   from_port         = -1  # All ICMP types
#   to_port           = -1  # All ICMP codes
#   cidr_ipv4         = "10.0.0.0/16"  # Restrict to your VPC (recommended)
#   # cidr_ipv4       = "0.0.0.0/0"    # Uncomment to allow public ping (insecure!)
# }


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