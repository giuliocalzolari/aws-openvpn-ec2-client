output "acm_certificate_arn" {
  description = "AWS ACM ARN"
  value       = "${aws_acm_certificate.cert.arn}"
}

output "aws_client_vpn_endpoint" {
  description = "AWS EC2 VPN Client Endpoint"
  value       = "vpn.${ replace(aws_ec2_client_vpn_endpoint.main.dns_name, "/^..(.*)/", "$1") }"
}
