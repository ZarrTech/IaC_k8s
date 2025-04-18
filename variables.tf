variable "vpc_id" {
  default = "vpc-0f0d1e9d205129fdb"
}

variable "instance_type" {
  description = "The type of instance to launch"
  default     = "t3.medium"
}

variable "bastion_instance_type" {
  description = "the time of instance to launch"
  default     = "t2.micro"
}

variable "region" {
  description = "The region to launch the instance in"
  default     = "us-east-1"

}

variable "az_index" {
  default = 0
}
