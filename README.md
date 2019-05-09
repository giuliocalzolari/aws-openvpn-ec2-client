# AWS EC2 VPN Client

quick repo how to configure your AWS OpenVPN client endpoint


```
git clone https://github.com/giuliocalzolari/aws-openvpn-ec2-client.git
cd aws-openvpn-ec2-client/
cd tests/
make apply
```


# WIP
it's a working progress


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| algorithm | Algorithm for Certificates | string | `"RSA"` | no |
| app\_name | app name | string | `"client-vpn"` | no |
| client\_cidr\_block | client CIRD BLco | string | `"192.168.0.0/22"` | no |
| clients | client config to create | list | `[ "client1" ]` | no |
| dns\_servers | DNS server for the Client | list | `[ "8.8.8.8","8.8.4.4" ]` | no |
| domain | domain to use | string | n/a | yes |
| ds\_id | AWS DS Id (required to be created before) | string | n/a | yes |
| environment | env to run | string | `"dev"` | no |
| extra\_tags | extra tags to add | map | n/a | yes |
| rsa\_bits | RSA Bit For Certificates | string | `"2048"` | no |
| subnet | subnet to associate the endpoint | string | n/a | yes |
| transport\_protocol | OpenVPN TRansport protocol | string | `"tcp"` | no |
| validity\_period\_hours | Certificate day validity | string | `"26280"` | no |

## Outputs

| Name | Description |
|------|-------------|
| acm\_certificate\_arn | AWS ACM ARN |
| aws\_client\_vpn\_endpoint | AWS EC2 VPN Client Endpoint |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Doc generation

Code formatting and documentation for variables and outputs is generated using [pre-commit-terraform hooks](https://github.com/antonbabenko/pre-commit-terraform) which uses [terraform-docs](https://github.com/segmentio/terraform-docs).


