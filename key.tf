resource "aws_key_pair" "main" {
  key_name = "${var.name}-key"
  public_key = "${var.public_key}"
}

resource "aws_key_pair" "slave" {
  key_name = "${var.name}-slave-key"
  public_key = "${var.slave_public_key}"
}

