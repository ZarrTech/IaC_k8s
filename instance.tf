#ec2 instance control plane creation
resource "aws_instance" "control_plane" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = var.instance_type
  key_name               = "k8s_key"
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  availability_zone      = "us-east-1a"
  tags = {
    Name    = "control-plane-instance"
    project = "k8s"
  }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = var.bastion_instance_type
  key_name               = "k8s_key"
  vpc_security_group_ids = [aws_security_group.k8s-sg.id]
  availability_zone      = "us-east-1a"
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
  availability_zone      = "us-east-1a"
  tags = {
    Name    = "worker-node-instance"
    project = "k8s"
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