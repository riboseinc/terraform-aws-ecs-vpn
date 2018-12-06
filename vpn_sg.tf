resource "aws_security_group" "vpn" {
  name_prefix = "${var.env}-${var.identifier}-vpn-"
  vpc_id = "${aws_vpc.main.id}"
  description = "${var.env}-${var.identifier}-vpn"

  tags {
    Name = "${var.env}-${var.identifier}-vpn"
  }
}

/* this is so we can troubleshoot from the office without needing a VPN connection
 */
resource "aws_security_group_rule" "vpn_ingress_ssh" {
  type = "ingress"
  from_port = "${var.ports["ssh"]}"
  to_port = "${var.ports["ssh"]}"
  protocol = "tcp"
  cidr_blocks = [
    "${var.ssh-ip}"
  ]

  security_group_id = "${aws_security_group.vpn.id}"
}

/* TODO: temporary until the Lambda function work
 */
resource "aws_security_group_rule" "vpn_ingress_openvpn" {
  type = "ingress"
  from_port = "${var.ports["openvpn"]}"
  to_port = "${var.ports["openvpn"]}"
  protocol = "tcp"
  cidr_blocks = [ "${var.vpn_cidr_block}" ]

  security_group_id = "${aws_security_group.vpn.id}"
}

resource "aws_security_group_rule" "vpn_ingress_icmp" {
  type = "ingress"
  from_port = "8"
  to_port = "0"
  protocol = "icmp"
  cidr_blocks = [ "${var.vpn_cidr_block}" ]

  security_group_id = "${aws_security_group.vpn.id}"
}

/* TODO: do not remove yet, this will be removed at a later stage
 */
resource "aws_security_group_rule" "vpn_egress_all" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = [ "${var.vpn_cidr_block}" ]

  security_group_id = "${aws_security_group.vpn.id}"
}
