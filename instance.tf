#ec2 instance control plane creation
resource "aws_instance" "control_plane" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = var.instance_type
  key_name               = "k8s_key"
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.k8s_master_profile.name
  subnet_id              = module.vpc.private_subnets[var.az_index]
  availability_zone      = [var.az_index]
  tags = {
    Name                                   = "control-plane-instance"
    project                                = "k8s"
    "kubernetes.io/cluster/k8s.lazaai.xyz" = "shared"
  }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = var.bastion_instance_type
  key_name               = "k8s_key"
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  subnet_id              = module.vpc.public_subnets[var.az_index]
  availability_zone      = [var.az_index]
  tags = {
    Name    = "bastion-instance"
    project = "k8s"
  }
}


#ec2 instance worker node creation
resource "aws_instance" "worker_node" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = var.instance_type
  key_name               = "k8s_key"
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  iam_instance_profile   = aws_iam_instance_profile.k8s_node_profile.name
  subnet_id              = module.vpc.private_subnets[var.az_index]
  availability_zone      = [var.az_index]
  tags = {
    Name                                   = "worker-node-instance"
    project                                = "k8s"
    "kubernetes.io/cluster/k8s.lazaai.xyz" = "shared"
  }

}


output "control_plane_ip" {
  description = "Private IP of the control plane instance"
  value       = aws_instance.control_plane.private_ip

}

output "worker_node_ip" {
  description = "Private IP of the worker node instance"
  value       = aws_instance.worker_node.private_ip

}

output "bastion_ip" {
  description = "Public IP of the bastion instance"
  value       = aws_instance.bastion.public_ip
}

output "bastion_instance_id" {
  description = "Instance ID of the bastion instance"
  value       = aws_instance.bastion.id
}

output "control_plane_instance_id" {
  description = "Instance ID of the control plane instance"
  value       = aws_instance.control_plane.id
}

output "worker_node_instance_id" {
  description = "Instance ID of the worker node instance"
  value       = aws_instance.worker_node.id
}

output "control_plane_dns" {
  value = aws_instance.control_plane.private_dns
}

output "worker_node_dns" {
  value = aws_instance.worker_node.private_dns
}