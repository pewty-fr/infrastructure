<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ovh"></a> [ovh](#requirement\_ovh) | 0.26.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement\_scaleway) | 2.8.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_db"></a> [db](#module\_db) | ./module/01-db | n/a |
| <a name="module_k3s"></a> [k3s](#module\_k3s) | ./module/03-k3s | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./module/00-network | n/a |
| <a name="module_vpn"></a> [vpn](#module\_vpn) | ./module/02-vpn | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_master_image"></a> [master\_image](#input\_master\_image) | Image for scw k3s master instance | `string` | n/a | yes |
| <a name="input_netmaker_access_key"></a> [netmaker\_access\_key](#input\_netmaker\_access\_key) | Access key to use netmaker | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Scaleway project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Scaleway region | `string` | n/a | yes |
| <a name="input_vpn_image"></a> [vpn\_image](#input\_vpn\_image) | Image for scw netmaker instance | `string` | n/a | yes |
| <a name="input_wg_iface"></a> [wg\_iface](#input\_wg\_iface) | Wireguard Interface | `string` | n/a | yes |
| <a name="input_worker_image"></a> [worker\_image](#input\_worker\_image) | Image for scw k3s worker instance | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Scaleway zone | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->