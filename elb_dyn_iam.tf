resource "aws_iam_policy" "dyn-elb-access" {
  name        = "${var.env}-${var.identifier}-dyn-elb-access-policy"
  description = "${var.env}-${var.identifier}-dyn-elb-access-policy"
  policy      = "${data.aws_iam_policy_document.dyn-elb-access.json}"
}

data "aws_iam_policy_document" "dyn-elb-access" {
  statement {
    effect    = "Allow"
    actions   = [
      "execute-api:Invoke"
    ]
    resources = [
      "${module.dyn-elb-access.execution_resources}"
    ]
  }
}

# Who can access the Lambda API (i.e., who can be added to the dynamic IAM group)
resource "aws_iam_group_policy_attachment" "dyn-elb-access" {
  group      = "${var.dyn-access-iam-group-name}"
# XXX TODO change this after Phuong is done
#  group      = "${var.env}-${var.identifier}-dyn-iam-access"
  policy_arn = "${aws_iam_policy.dyn-elb-access.arn}"
}

