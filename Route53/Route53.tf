resource "aws_route53_zone" "dns" {
  name = "<Domain>"

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

# resource "aws_route53_record" "a" {
#   zone_id = aws_route53_zone.dns.zone_id
#   name = "<Recrod>.<Domain>"
#   type = "A"
#   ttl = 60
#   records = [ aws_instance.public_ip ]
# }

# resource "aws_route53_record" "cname" {
#   zone_id = aws_route53_zone.dns.zone_id
#   name = "<Recrod>.<Domain>"
#   type = "CNAME"
#   ttl = 60
#   records = [ aws_lb.web.dns_name ]
# }