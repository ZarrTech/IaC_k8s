# 🚀 Public Hosted Zone for External Access
resource "aws_route53_zone" "public" {
  name = "k8s.lazaai.xyz"
}


# # 🎯 Public API Endpoint (External Kubernetes Access)
# resource "aws_route53_record" "public_api" {
#   zone_id = aws_route53_zone.public.zone_id
#   name    = "api.k8s.lazaai.xyz"
#   type    = "A"
#   ttl     = 300
#   records = [aws_instance.control_plane.public_ip]
# }

# 🎯 Public Load Balancer (External Access to Services)
# resource "aws_route53_record" "public_lb" {
#   zone_id = aws_route53_zone.public.zone_id
#   name    = "k8s.lazaai.xyz"
#   type    = "A"

#   alias {
#     name                   = "a34f3c2f.elb.amazonaws.com" # from kubectl get svc
#     zone_id                = "Z32O12XQLNTSW2"             # use `aws elb describe-load-balancers`
#     evaluate_target_health = true
#   }
# }

resource "aws_route53_record" "bastion_dns" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "bastion.lazaai.xyz"
  type    = "A"
  ttl     = 60
  records = [aws_instance.bastion.public_ip]
}

# ✅ Output Name Servers
output "name_servers" {
  value = aws_route53_zone.public.name_servers
}
