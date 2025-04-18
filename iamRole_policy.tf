#master policy
resource "aws_iam_policy" "k8s_master_policy" {
  name        = "K8sInstancePolicy"
  description = "Policy for EC2 instance to run Kubespray"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["ec2:*"],
        "Resource" : ["*"]
      },
      {
        "Effect" : "Allow",
        "Action" : ["elasticloadbalancing:*"],
        "Resource" : ["*"]
      },
      {
        "Effect" : "Allow",
        "Action" : ["route53:*"],
        "Resource" : ["*"]
      },
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::kubernetes-*"
        ]
      }
    ]
  })
}

# node policy
resource "aws_iam_policy" "k8s_node_policy" {
  name        = "K8sInstancePolicy"
  description = "Policy for EC2 instance to run Kubespray"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::kubernetes-*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:Describe*",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:AttachVolume",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : "ec2:DetachVolume",
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : ["route53:*"],
        "Resource" : ["*"]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage"
        ],
        "Resource" : "*"
      }
    ]
  })
}

#master role
resource "aws_iam_role" "k8s_master_ec2_role" {
  name = "k8s-ec2-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : { "Service" : "ec2.amazonaws.com" },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

#node role
resource "aws_iam_role" "k8s_node_ec2_role" {
  name = "k8s-ec2-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : { "Service" : "ec2.amazonaws.com" },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Attach the policy to the master role
resource "aws_iam_role_policy_attachment" "k8s_master_attach" {
  role       = aws_iam_role.k8s_master_ec2_role.name
  policy_arn = aws_iam_policy.k8s_master_policy.arn
}

# Attach the policy to the node role
resource "aws_iam_role_policy_attachment" "k8s_node_attach" {
  role       = aws_iam_role.k8s_node_ec2_role.name
  policy_arn = aws_iam_policy.k8s_node_policy.arn
}

#instance master profile
resource "aws_iam_instance_profile" "k8s_master_profile" {
  name = "k8s-instance-profile"
  role = aws_iam_role.k8s_master_ec2_role.name
}

# instance node profile
resource "aws_iam_instance_profile" "k8s_node_profile" {
  name = "k8s-instance-profile"
  role = aws_iam_role.k8s_node_ec2_role.name
}


