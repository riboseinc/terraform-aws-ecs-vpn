/* ecs service cluster
 */
resource "aws_ecs_cluster" "main" {
  name = "${var.env}-${var.identifier}-ecs"
}

resource "aws_launch_configuration" "main" {
  name_prefix = "${var.env}-${var.identifier}-launch-cfg-"
  image_id = "${data.aws_ami.ecs.id}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.main.key_name}"
  associate_public_ip_address = true

  security_groups = [ "${aws_security_group.ecs.id}" ]
  iam_instance_profile = "${aws_iam_instance_profile.main.name}"
  user_data = "${var.bootstrap}"
  ebs_optimized = true

  root_block_device {
    delete_on_termination = true
  }

  ebs_block_device {
/* Recommended range for HVM: /dev/sd[f-p]
  http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html
*/
    device_name = "/dev/sdf"
    encrypted = true
    delete_on_termination = true
    volume_type = "gp2"
    volume_size = 100
  }

  /* this is a requirement to handle autoscaling group launch configuration updates */
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {
  name = "${var.env}-${var.identifier}-as-ecs"
  launch_configuration = "${aws_launch_configuration.main.name}"
  availability_zones = [
    "${aws_subnet.primary.availability_zone}"
  ]
  health_check_grace_period = 10
  health_check_type = "EC2"
  force_delete = true

  min_size = "${var.enable-asg == "true" ? 1 : 0}"
  max_size = "${var.enable-asg == "true" ? 1 : 0}"
  desired_capacity = "${var.enable-asg == "true" ? 1 : 0}"

  vpc_zone_identifier = [ "${aws_subnet.primary.id}" ]

  lifecycle {
    create_before_destroy = true
  }

  load_balancers = [
    "${var.elb-int-name}"
  ]

  tag {
    key = "Name"
    value = "${var.env}-${var.identifier}-ecs-instance"
    propagate_at_launch = true
  }

  tag {
    key = "DEPLOYMENT"
    value = "${var.env}-${var.identifier}"
    propagate_at_launch = true
  }

  /* Used by boot.sh to retrieve the ECS Cluster ID
   */
  tag {
    key = "ECS_CLUSTER"
    value = "${aws_ecs_cluster.main.name}"
    propagate_at_launch = true
  }

  /* Used by boot.sh to retrieve the EBS ID
   */
  tag {
    key = "EBS_VOLUME_ID"
    value = "${var.ebs-id}"
    propagate_at_launch = true
  }

  /* Used by boot.sh to retrieve the ECS Cluster ID
   */
  tag {
    key = "BOOTSTRAP_ROLE"
    value = "${var.name}"
    propagate_at_launch = true
  }

  tag {
    key = "INFRASTRUCTURE_RELEASE"
    value = "${var.infrastructure_release}"
    propagate_at_launch = true
  }
}