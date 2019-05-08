# AWS EC2 VPN Client

quick repo how to configure your AWS OpenVPN client endpoint


```
git clone https://github.com/giuliocalzolari/aws-openvpn-ec2-client.git
cd aws-openvpn-ec2-client/
cd tests/
make apply
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| algorithm | Algorithm for Certificates | string | `"RSA"` | no |
| app\_name | app name | string | `"client-vpn"` | no |
| client\_cidr\_block | client CIRD BLco | string | `"192.168.0.0/22"` | no |
| clients | client config to create | list | `<list>` | no |
| dns\_servers | DNS server for the Client | list | `<list>` | no |
| domain | domain to use | string | n/a | yes |
| ds\_id | AWS DS Id (required to be created before) | string | n/a | yes |
| environment | env to run | string | `"dev"` | no |
| extra\_tags | extra tags to add | map | n/a | yes |
| rsa\_bits | RSA Bit For Certificates | string | `"2048"` | no |
| subnet | subnet to associate the endpoint | string | n/a | yes |
| transport\_protocol | OpenVPN TRansport protocol | string | `"tcp"` | no |
| validity\_period\_hours | Certificate day validity | string | `"26280"` | no |


# WIP
it's a working progress