resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    Name = "vpc-${var.env}"
  }
}

/* an internet gateway is required if a machine inside a VPC
 * needs to access the internet
 */
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.env}-${var.identifier}-gw"
  }
}

/* after setting up an internet gateway a default route to the internet
 * is needed
 */
resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags {
    Name = "${var.env}-${var.identifier}-route-table"
  }
}

resource "aws_main_route_table_association" "main" {
  vpc_id = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.main.id}"
}

/* at least one subnet is needed inside a VPC
 * and enable internet IPs
 */
resource "aws_subnet" "primary" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, 1)}"
  availability_zone = "${data.aws_availability_zones.main.names[0]}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.env}-${var.identifier}-primary"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, 2)}"
  availability_zone = "${data.aws_availability_zones.main.names[2]}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.env}-${var.identifier}-secondary"
  }
}

