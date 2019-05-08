variable "region" {
  default = "eu-central-1"
}


provider "aws" {
  region = "${var.region}"
}


module "vpc-ovpn" {
  source = "terraform-aws-modules/vpc/aws"

  enable_dns_hostnames = true
  enable_dns_support = true

  name = "client-vpn-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnets  = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]

  tags = {
    Terraform = "true"
    App = "OpenVPN"
  }
}





module "ovpn" {
    source  = "git@github.com:giuliocalzolari/aws-openvpn-ec2-client.git"
    ds_id   = "d-9967362dd3"
    domain  =  "vpn.gc.cloud"
    clients = ["client1"]
    subnet  = "${element(module.vpc-ovpn.public_subnets, 0)}"
    environment = "dev"
    extra_tags = {
        Terraform = "true"
        App = "OpenVPN"
    }
}