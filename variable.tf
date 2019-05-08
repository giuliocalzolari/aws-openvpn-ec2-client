variable "environment" {
	default = "dev"
}

variable "app_name" {
	default = "client-vpn"
}

variable "ds_id" {
  default = "d-9967362dd3"
}

variable "subnet" {
  default = ""
}


variable "client_cidr_block" {
  default = "192.168.0.0/22"
}

variable "transport_protocol" {
  default = "tcp"
}

variable "dns_servers" {
  default = ["10.0.0.2"]
}


variable "rsa_bits" {
  default = "2048"
}

variable "algorithm" {
  default = "RSA"
}

variable "domain" {
  default = "vpn.gc.cloud"
}

variable "validity_period_hours" {
  default = 26280
}


variable "clients" {
  default = ["client1"]
}



variable "extra_tags" {
  type = "map"
}
