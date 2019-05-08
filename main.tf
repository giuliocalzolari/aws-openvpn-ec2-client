resource "aws_cloudwatch_log_group" "cwlog" {
  name              = "/aws/ec2/${var.environment}-${var.app_name}"
  retention_in_days = 30

  tags = "${merge(
        var.extra_tags,
        map("Name", "/aws/ec2/${var.environment}-${var.app_name}"),
        )}"
}

resource "aws_ec2_client_vpn_endpoint" "main" {
  description            = "vpn"
  server_certificate_arn = "${aws_acm_certificate.cert.arn}"
  client_cidr_block      = "${var.client_cidr_block}"
  transport_protocol     = "${var.transport_protocol}"
  dns_servers            = ["${var.dns_servers}"]

  authentication_options {
    type                = "directory-service-authentication"
    active_directory_id = "${var.ds_id}"
  }

  connection_log_options {
    enabled              = true
    cloudwatch_log_group = "${aws_cloudwatch_log_group.cwlog.name}"
  }

  tags = "${merge(
        var.extra_tags,
        map("Name", "${var.environment}-${var.app_name}"),
        )}"
}

resource "aws_ec2_client_vpn_network_association" "main-assoc" {
  client_vpn_endpoint_id = "${aws_ec2_client_vpn_endpoint.main.id}"
  subnet_id              = "${var.subnet}"
}

resource "local_file" "client_ovpn" {
  count    = "${length(var.clients)}"
  filename = "./certs/${var.clients[count.index]}.ovpn"

  content = <<EOF
client
dev tun
proto tcp
remote vpn.${ replace(aws_ec2_client_vpn_endpoint.main.dns_name, "/^..(.*)/", "$1") } 443
remote-random-hostname
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-GCM
verb 3
<ca>
${tls_self_signed_cert.root_ca.0.cert_pem}</ca>
<cert>
${element(tls_locally_signed_cert.client.*.cert_pem, count.index)}</cert>
<key>
${element(tls_private_key.client.*.private_key_pem, count.index)}</key>
auth-user-pass
reneg-sec 0
EOF
}
