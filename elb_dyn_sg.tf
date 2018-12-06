resource "aws_security_group" "dyn-elb" {
  name = "${var.env}-${var.identifier}-dyn-elb"
  vpc_id = "${aws_vpc.main.id}"
  description = "${var.env}-${var.identifier}-dyn-elb"

  tags {
    Name = "${var.env}-${var.identifier}-dyn-elb"
  }
}

module "dyn-elb-access" {
  source = "github.com/riboseinc/terraform-aws-authenticating-secgroup"

  name = "${var.env}-${var.identifier}-dyn-elb"
  description = "${var.env}-${var.identifier}-dyn-elb"

  # Time to expiry for every rule.
  # Default: 600 seconds.
  time_to_expire = 600

  log_level = "DEBUG"
  bucket_name = "${var.dyn-iam-s3-bucket}"

  security_groups = [
    {
  		"group_ids" = [
  			"${aws_security_group.dyn-elb.id}"
  		],
  		"rules" = [
  			{
  				"type" = "ingress",
  				"from_port" = "${var.ports["https"]}",
  				"to_port" = "${var.ports["https"]}",
  				"protocol" = "tcp"
  			}
  		],
  		"region_name" = "${var.aws-region}"
  	}
  ]
}
