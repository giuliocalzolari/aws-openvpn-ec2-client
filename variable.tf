variable "environment" {
  description = "env to run"
  default     = "dev"
}

variable "app_name" {
  description = "app name"
  default     = "client-vpn"
}

variable "ds_id" {
  description = "AWS DS Id (required to be created before)"
}

variable "subnet" {
  description = "subnet to associate the endpoint"
}

variable "client_cidr_block" {
  description = "client CIDR Block"
  default     = "192.168.240.0/22"
}

variable "transport_protocol" {
  description = "OpenVPN TRansport protocol"
  default     = "tcp"
}

variable "dns_servers" {
  description = "DNS server for the Client"
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "rsa_bits" {
  description = "RSA Bit For Certificates"
  default     = "2048"
}

variable "algorithm" {
  description = "Algorithm for Certificates"
  default     = "RSA"
}

variable "domain" {
  description = "domain to use"
}

variable "validity_period_hours" {
  description = "Certificate day validity"
  default     = 26280
}

variable "clients" {
  description = "client config to create "
  default     = ["client1"]
}

variable "extra_tags" {
  description = "extra tags to add"
  type        = "map"
}
