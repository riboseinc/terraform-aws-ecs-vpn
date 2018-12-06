output "deployment-name" {
  value = "${var.env}-${var.identifier}"
}

output "sg-name" {
  value = "${aws_security_group.ecs.name}"
}

output "sg-id" {
  value = "${aws_security_group.ecs.id}"
}

output "ecs-instance-role-id" {
  value = "${aws_iam_role.ecs_instance_role.id}"
}

output "ecs-cluster-name" {
  value = "${aws_ecs_cluster.main.name}"
}

output "ecs-cluster-id" {
  value = "${aws_ecs_cluster.main.id}"
}

output "iam-instance-profile-arn" {
  value = "${aws_iam_instance_profile.main.arn}"
}

output "key-name" {
  value = "${aws_key_pair.main.key_name}"
}

output "slave-key-name" {
  value = "${aws_key_pair.slave.key_name}"
}

output "r53-public-zone-zoneid" {
  value = "${aws_route53_zone.public.zone_id}"
}

output "r53-public-zone-id" {
  value = "${aws_route53_zone.public.id}"
}

output "r53-public-zone-name" {
  value = "${aws_route53_zone.public.name}"
}

output "r53-public-ns" {
  value = "${aws_route53_zone.public.name_servers}"
}

output "r53-internal-zone-zoneid" {
  value = "${aws_route53_zone.internal.zone_id}"
}

output "r53-internal-zone-id" {
  value = "${aws_route53_zone.internal.id}"
}

output "r53-internal-zone-name" {
  value = "${aws_route53_zone.internal.name}"
}

output "r53-internal-ns" {
  value = "${aws_route53_zone.internal.name_servers}"
}

output "vpc-id" {
  value = "${aws_vpc.main.id}"
}

output "vpc-cidr" {
  value = "${aws_vpc.main.cidr_block}"
}

output "aws-region-az-primary" {
  value = "${aws_subnet.primary.availability_zone}"
}

output "aws-region-az-secondary" {
  value = "${aws_subnet.secondary.availability_zone}"
}

output "vpc-subnet-primary-id" {
  value = "${aws_subnet.primary.id}"
}

output "vpc-subnet-secondary-id" {
  value = "${aws_subnet.secondary.id}"
}

output "vpc-subnet-primary-cidr" {
  value = "${aws_subnet.primary.cidr_block}"
}

output "vpc-subnet-secondary-cidr" {
  value = "${aws_subnet.secondary.cidr_block}"
}

output "iam-certificate-id" {
  value = "${aws_iam_server_certificate.main.id}"
}

output "iam-certificate-arn" {
  value = "${aws_iam_server_certificate.main.arn}"
}

output "ecs-scheduler-role-arn" {
  value = "${aws_iam_role.ecs-scheduler-role.arn}"
}