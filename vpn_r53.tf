
# this record is used in the .ovpn file
resource "aws_route53_record" "vpn-endpoint" {
  zone_id = "${aws_route53_zone.public.id}"
  name    = "vpn-endpoint.${aws_route53_zone.public.name}"
  type    = "A"
  ttl     = "300"
  records = [ "${aws_eip.vpn.public_ip}" ]
}
