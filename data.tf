data "aws_availability_zones" "main" {
  state = "available"
}

data "aws_ami" "ecs" {
  most_recent = true
  executable_users = [ "self" ]
  filter {
    name = "state"
    values = [ "available" ]
  }
  filter {
    name = "owner-id"
    values = [ "${var.aws-ami-account-id}" ]
  }
  filter {
    name = "name"
    values = [ "${var.ami-ecs}" ]
  }
  owners = [ "${var.aws-ami-account-id}" ]
}

data "aws_ami" "vpn" {
  most_recent = true
  executable_users = [ "self" ]
  filter {
    name = "state"
    values = [ "available" ]
  }
  filter {
    name = "owner-id"
    values = [ "${var.aws-ami-account-id}" ]
  }
  filter {
    name = "name"
    values = [ "${var.ami-vpn}" ]
  }
  owners = [ "${var.aws-ami-account-id}" ]
}
