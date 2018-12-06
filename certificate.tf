resource "aws_iam_server_certificate" "main" {
  name_prefix = "${var.name}-"

  certificate_body = "${var.file-ssl-cert-body}"
  certificate_chain = "${var.file-ssl-cert-chain}"
  private_key = "${var.file-ssl-cert-key}"
  path = "/${var.name}/"

  lifecycle {
    create_before_destroy = true
  }

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

