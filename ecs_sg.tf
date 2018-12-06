resource "aws_security_group" "ecs" {
  name = "${var.env}-${var.identifier}-ecs-sg"
  vpc_id = "${aws_vpc.main.id}"
  description = "${var.env}-${var.identifier}-ecs-sg"

  tags {
    Name = "${var.env}-${var.identifier}-ecs-sg"
  }
}

