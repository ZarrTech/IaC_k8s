resource "aws_key_pair" "name" {
  key_name   = "k8s_key"
  public_key = file("k8s_key.pub")
}