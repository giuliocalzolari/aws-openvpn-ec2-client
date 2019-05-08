// root ca is self-signed
resource "tls_private_key" "root_ca" {
  algorithm = "${var.algorithm}"
  rsa_bits  = "${var.rsa_bits}"
}

resource "local_file" "root_ca_key" {
  content  = "${tls_private_key.root_ca.0.private_key_pem}"
  filename = "./certs/root_ca.key"
}

resource "tls_self_signed_cert" "root_ca" {
  key_algorithm   = "${tls_private_key.root_ca.algorithm}"
  private_key_pem = "${tls_private_key.root_ca.private_key_pem}"

  subject {
    common_name = "ca"
  }

  is_ca_certificate     = true
  validity_period_hours = "${var.validity_period_hours}"

  allowed_uses = [
    "crl_signing",
    "cert_signing",
  ]
}

resource "local_file" "root_ca_cert" {
  content  = "${tls_self_signed_cert.root_ca.0.cert_pem}"
  filename = "./certs/root_ca.crt"
}

// server certs and key.
resource "tls_private_key" "server" {
  algorithm = "${var.algorithm}"
  rsa_bits  = "${var.rsa_bits}"
}

resource "local_file" "server_key" {
  content  = "${tls_private_key.server.0.private_key_pem}"
  filename = "./certs/server.${var.domain}.key"
}

resource "tls_cert_request" "server" {
  key_algorithm   = "${tls_private_key.server.0.algorithm}"
  private_key_pem = "${tls_private_key.server.0.private_key_pem}"

  subject {
    common_name = "server.${var.domain}"
  }
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem = "${tls_cert_request.server.0.cert_request_pem}"

  ca_key_algorithm   = "${tls_private_key.root_ca.algorithm}"
  ca_private_key_pem = "${tls_private_key.root_ca.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.root_ca.0.cert_pem}"

  validity_period_hours = "${var.validity_period_hours}"

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "local_file" "server_cert" {
  content  = "${tls_locally_signed_cert.server.0.cert_pem}"
  filename = "./certs/server.${var.domain}.crt"
}



# 
# mkdir ssl
# cd ssl
# git clone https://github.com/OpenVPN/easy-rsa.git
# cd easy-rsa/easyrsa3
# ./easyrsa init-pki
# ./easyrsa build-ca nopass
# ./easyrsa build-server-full server nopass
# ./easyrsa build-client-full client1.domain.tld nopass

# resource "aws_acm_certificate" "cert" {
#   private_key      = "${file("./ssl/easy-rsa/easyrsa3/pki/private/server.${local.domain}.key")}"
#   certificate_body = "${file("./ssl/easy-rsa/easyrsa3/pki/issued/server.${local.domain}.crt")}"
#   certificate_chain = "${file("./ssl/easy-rsa/easyrsa3/pki/ca.crt")}"
# }

// client cert and keys
resource "tls_private_key" "client" {
  count     = "${length(var.clients)}"
  algorithm = "${var.algorithm}"
  rsa_bits  = "${var.rsa_bits}"
}

resource "local_file" "client_key" {
  count    = "${length(var.clients)}"
  content  = "${element(tls_private_key.client.*.private_key_pem, count.index)}"
  filename = "./certs/${var.clients[count.index]}.key"
}

resource "random_id" "serial_id" {
  keepers = {
    name = "vpn"
  }

  byte_length = 8
}

resource "tls_cert_request" "client" {
  count           = "${length(var.clients)}"
  key_algorithm   = "${element(tls_private_key.client.*.algorithm, count.index)}"
  private_key_pem = "${element(tls_private_key.client.*.private_key_pem, count.index)}"

  subject {
    common_name   = "${var.clients[count.index]}.${var.domain}"
    serial_number = "${random_id.serial_id.hex}"
  }

  dns_names = ["${var.clients[count.index]}.${var.domain}"]
}

resource "tls_locally_signed_cert" "client" {
  count            = "${length(var.clients)}"
  cert_request_pem = "${element(tls_cert_request.client.*.cert_request_pem, count.index)}"

  ca_key_algorithm   = "${tls_private_key.root_ca.algorithm}"
  ca_private_key_pem = "${tls_private_key.root_ca.private_key_pem}"
  ca_cert_pem        = "${tls_self_signed_cert.root_ca.0.cert_pem}"

  validity_period_hours = "${var.validity_period_hours}"

  allowed_uses = [
    "digital_signature",
    "client_auth",
  ]
}

resource "local_file" "client_cert" {
  count    = "${length(var.clients)}"
  content  = "${element(tls_locally_signed_cert.client.*.cert_pem, count.index)}"
  filename = "./certs/${var.clients[count.index]}.crt"
}




resource "aws_acm_certificate" "cert" {
  private_key       = "${tls_private_key.server.0.private_key_pem}"
  certificate_body  = "${tls_locally_signed_cert.server.0.cert_pem}"
  certificate_chain = "${tls_self_signed_cert.root_ca.0.cert_pem}"
  tags = "${merge(
        var.extra_tags,
        map("Name", "${var.environment}-${var.app_name}-server-cert"),
        )}"   
}