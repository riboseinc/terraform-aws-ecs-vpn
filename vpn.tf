resource "aws_iam_instance_profile" "vpn" {
  name = "${var.env}-${var.identifier}-vpn-instance-profile"
  role = "${aws_iam_role.vpn.name}"
}

resource "aws_launch_configuration" "vpn" {
  image_id = "${data.aws_ami.vpn.id}"
  instance_type = "${var.instance_type_vpn}"
  name_prefix = "${var.env}-${var.identifier}-vpn-launch-cfg-"

  iam_instance_profile = "${aws_iam_instance_profile.vpn.name}"
  key_name = "${aws_key_pair.main.key_name}"
  security_groups = [
#    "${aws_security_group.dyn_vpn.id}",
    "${aws_security_group.vpn.id}"
  ]

  user_data = "${var.bootstrap}"

  /* this is a requirement to handle autoscaling group launch configuration updates */
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "vpn" {
  name = "${var.env}-${var.identifier}-as-vpn"
  availability_zones = [ "${data.aws_availability_zones.main.names[0]}" ]

  vpc_zone_identifier = [ "${aws_subnet.primary.id}" ]

  min_size = 1
  max_size = 1
  desired_capacity = 1

  health_check_grace_period = 10
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.vpn.name}"

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "${var.env}-${var.identifier}-vpn"
    propagate_at_launch = true
  }

  # TODO: turn this into a global variable so that the Jenkins ECS can also use it
  tag {
    key = "INFRASTRUCTURE_RELEASE"
    value = "${var.infrastructure_release}"
    propagate_at_launch = true
  }

  tag {
    key = "DEPLOYMENT"
    value = "${var.env}-${var.identifier}"
    propagate_at_launch = true
  }

  tag {
    key = "BOOTSTRAP_ROLE"
    value = "vpn"
    propagate_at_launch = true
  }

  /* OpenVPN creates a private network between the client and the server,
   * the client then uses this private network to NAT out using the server
   * its private IP address
   */
  tag {
    key = "OPENVPNPRIVATE"
    value = "${cidrsubnet(var.vpc_cidr, 4, 1)}"
    propagate_at_launch = true
  }

  tag {
    key = "OPENVPNPRIVATEMASK"
    value = "${cidrnetmask(cidrsubnet(var.vpc_cidr, 4, 1))}"
    propagate_at_launch = true
  }

  tag {
    key = "EIP"
    value = "${aws_eip.vpn.id}"
    propagate_at_launch = true
  }
}

/* This is necessary to reserve this IP address for the instance */
resource "aws_eip" "vpn" {
/*  associate_with_private_ip = "${var.vpn-private-ip}" */
  vpc = true
}
