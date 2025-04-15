# 🚀 Public Hosted Zone for External Access
resource "aws_route53_zone" "public" {
  name = "k8s.lazaai.xyz"
}


# 🎯 Public API Endpoint (External Kubernetes Access)
resource "aws_route53_record" "public_api" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "api.k8s.lazaai.xyz"
  type    = "A"
  ttl     = 300
  records = [aws_instance.control_plane.public_ip]
}

# 🎯 Tomcat Service DNS (behind AWS Load Balancer)
# resource "aws_route53_record" "tomcat" {
#   zone_id = aws_route53_zone.public.zone_id
#   name    = "app.lazaai.xyz"
#   type    = "A"
#   ttl     = 300
#   records = [aws_lb.tomcat.dns_name]
# }

# ✅ Output Name Servers
output "name_servers" {
  value = aws_route53_zone.public.name_servers
}
