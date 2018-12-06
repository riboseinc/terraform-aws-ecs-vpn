resource "aws_iam_role" "vpn" {
  name = "${var.env}-${var.identifier}-vpn-role"
  assume_role_policy = "${data.aws_iam_policy_document.vpn-assume.json}"
}

data "aws_iam_policy_document" "vpn-assume" {
  statement {
    actions = [ "sts:AssumeRole" ]
    effect = "Allow"
    principals = {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "vpn" {
  name = "${var.env}-${var.identifier}-vpn-role-policy"
  role = "${aws_iam_role.vpn.id}"
  policy = "${data.aws_iam_policy_document.vpn-role.json}"
}

data "aws_iam_policy_document" "vpn-role" {
  statement {
    sid = "AllowDescribeForVpnDeploymentBootstrapRole"
    effect = "Allow"
    actions = [ "ec2:DescribeInstances" ]
    resources = [ "*" ]
  }

  /* BEGIN used by git pull from other account's CodeCommit repo */
  statement {
    sid = "AllowVPNGitPullDelegation"
    effect = "Allow"
    actions = [ "sts:AssumeRole" ]
    resources = "${var.allow-vpn-git-pull-roles}"
  }
  /* END used by git pull from other account's CodeCommit repo */

  statement {
    sid = "GetSSHPublicKeysForEC2SSHusers"
    effect = "Allow"
    actions = [
      "iam:ListUsers",
      "iam:ListSSHPublicKeys",
      "iam:GetSSHPublicKey",
      "iam:GetGroup"
    ]
    resources = [ "*" ]
  }

  statement {
    sid = "EIPoperations"
    effect = "Allow"
    actions = [
      "ec2:AssociateAddress",
      "ec2:DisassociateAddress"
    ]
    resources = [ "*" ]
  }
}
