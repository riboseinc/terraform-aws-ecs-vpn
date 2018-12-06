resource "aws_iam_policy" "dyn-vpn-access" {
  name        = "${var.env}-${var.identifier}-dyn-vpn-access-policy"
  description = "${var.env}-${var.identifier}-dyn-vpn-access-policy"
  policy      = "${data.aws_iam_policy_document.dyn-vpn-access.json}"
}

data "aws_iam_policy_document" "dyn-vpn-access" {
  statement {
    effect    = "Allow"
    actions   = [
      "execute-api:Invoke"
    ]
    resources = [
      "${module.dyn-vpn-access.execution_resources}"
    ]
  }
}

# Who can access the Lambda API (i.e., who can be added to the dynamic security group)
resource "aws_iam_group_policy_attachment" "dyn-vpn-access-operators" {
  group      = "${var.dyn-access-iam-group-name}"
  policy_arn = "${aws_iam_policy.dyn-vpn-access.arn}"
}
