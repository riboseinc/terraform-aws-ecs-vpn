resource "aws_security_group" "dyn_vpn" {
  name = "${var.env}-${var.identifier}-dyn-vpn"
  vpc_id = "${aws_vpc.main.id}"
  description = "${var.env}-${var.identifier}-dyn-vpn"

  tags {
    Name = "${var.env}-${var.identifier}-dyn-vpn"
  }
}

module "dyn-vpn-access" {
  source = "github.com/riboseinc/terraform-aws-authenticating-secgroup"

  name = "${var.env}-${var.identifier}-dyn-vpn"

  description = "${var.env}-${var.identifier}-dyn-vpn-access"

  deployment_stage = "dev"

  # Time to expiry for every rule.
  # Default: 600 seconds.
  time_to_expire = 600

  log_level = "DEBUG"
  bucket_name = "${var.dyn-iam-s3-bucket}"

  security_groups = [
	{
		"group_ids" = [
			"${aws_security_group.dyn_vpn.id}"
		],
		"rules" = [
			{
				"type" = "ingress",
				"from_port" = "${var.ports["openvpn"]}",
				"to_port" = "${var.ports["openvpn"]}",
				"protocol" = "tcp"
			}
		],
		"region_name" = "${var.aws-region}"
	}
  ]
}
