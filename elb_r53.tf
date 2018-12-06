# this record is for the Lamdba ELB authentication endpoint
resource "aws_route53_record" "elb-auth-endpoint" {
  zone_id = "${aws_route53_zone.public.id}"
  name    = "elb-auth.${aws_route53_zone.public.name}"
  type    = "CNAME"
  ttl     = "5"

  weighted_routing_policy {
    weight = 10
  }

  set_identifier = "live"
  records = [ "${replace(replace(module.dyn-elb-access.invoke_url, "https://", ""), "/dev/connection", "")}" ]
}
