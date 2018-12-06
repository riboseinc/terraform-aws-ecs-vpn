/* These records are public */
resource "aws_route53_zone" "public" {
  name = "${var.name}.${var.dns-public-name}"
  comment = "${var.name}.${var.dns-public-name}"
}

/* These records are private */
resource "aws_route53_zone" "internal" {
  name = "${var.dns-internal-name}"
  comment = "${var.dns-internal-name}"
  vpc {
    vpc_id = "${aws_vpc.main.id}"
  }
}
