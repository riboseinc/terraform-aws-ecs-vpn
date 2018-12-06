resource "aws_iam_instance_profile" "main" {
  name = "${var.env}-${var.identifier}-ecs-instance-profile"
  role = "${aws_iam_role.ecs_instance_role.name}"
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.env}-${var.identifier}-iam-ecs-service-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-assume-role.json}"
}

# TODO: This is probably useless, remove?
data "aws_iam_policy_document" "ecs-assume-role" {
  statement {
    sid = "ServiceAssumeEcsRole"
    actions = [ "sts:AssumeRole" ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com",
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs-scheduler-role" {
  name = "${var.env}-${var.identifier}-ecs-scheduler-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-scheduler-assume-policy.json}"
}

data "aws_iam_policy_document" "ecs-scheduler-assume-policy" {
  statement {
    sid = "ServiceAssumeEcsRole"
    actions = [ "sts:AssumeRole" ]
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "ecs.amazonaws.com",
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-service-role" {
  role = "${aws_iam_role.ecs-scheduler-role.id}"
  policy_arn = "${aws_iam_policy.ecs-service-role-policy.arn}"
}

resource "aws_iam_policy" "ecs-service-role-policy" {
  name = "${var.env}-${var.identifier}-ecs-service-role-policy"
  policy = "${data.aws_iam_policy_document.ecs-service-role-policy.json}"
}

data "aws_iam_policy_document" "ecs-service-role-policy" {
  statement {
    sid = "EcsServicePolicy"
    /*
      https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service_IAM_role.html
      AmazonEC2ContainerServiceRole
    */

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
    ]
    effect = "Allow"
    resources = [ "*" ]
  }
}

resource "aws_iam_role_policy_attachment" "ecs-instance" {
  role = "${aws_iam_role.ecs_instance_role.id}"
  policy_arn = "${aws_iam_policy.ecs-instance-role-policy.arn}"
}

resource "aws_iam_policy" "ecs-instance-role-policy" {
  name = "${var.env}-${var.identifier}-ecs-instance-role-policy"
  policy = "${data.aws_iam_policy_document.ecs-instance-role.json}"
}


data "aws_iam_policy_document" "ecs-instance-role" {

  statement {
    sid = "AllowECSECREC2"
    effect = "Allow"
    actions = [

      /* BEGIN AmazonEC2ContainerServiceforEC2Role */
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecs:DescribeClusters",
      "ecs:RunTask",
      "ecs:StopTask",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      /* END AmazonEC2ContainerServiceforEC2Role */
    ]
    resources = [ "*" ]
  }

}

