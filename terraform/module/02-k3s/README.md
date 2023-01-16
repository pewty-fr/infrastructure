<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ovh"></a> [ovh](#requirement\_ovh) | 0.26.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement\_scaleway) | 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_scaleway"></a> [scaleway](#provider\_scaleway) | 2.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_password.k3s_agent_token](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [random_password.k3s_token](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [scaleway_instance_ip.ip](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/resources/instance_ip) | resource |
| [scaleway_instance_server.k3s_master](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/resources/instance_server) | resource |
| [scaleway_instance_server.k3s_worker](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/resources/instance_server) | resource |
| [scaleway_account_project.by_project_id](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/data-sources/account_project) | data source |
| [scaleway_instance_image.master](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/data-sources/instance_image) | data source |
| [scaleway_instance_image.worker](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/data-sources/instance_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db"></a> [db](#input\_db) | description | <pre>object({<br>    public_ip    = string<br>    public_port  = string<br>    private_ip   = string<br>    private_port = string<br>    name         = string<br>    user         = string<br>    password     = string<br>  })</pre> | n/a | yes |
| <a name="input_master_image"></a> [master\_image](#input\_master\_image) | Image for scw k3s master instance | `string` | n/a | yes |
| <a name="input_netmaker_access_key"></a> [netmaker\_access\_key](#input\_netmaker\_access\_key) | Access key to use netmaker | `string` | n/a | yes |
| <a name="input_pool"></a> [pool](#input\_pool) | description | <pre>object({<br>    ip      = string<br>    netmask = string<br>    db = map(object({<br>      ip = string<br>    }))<br>    vpn = map(object({<br>      ip = string<br>    }))<br>    k3s_master = map(object({<br>      ip = string<br>    }))<br>    k3s_worker = map(object({<br>      ip = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_private_network_id"></a> [private\_network\_id](#input\_private\_network\_id) | ID of the private network | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Scaleway project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Scaleway region | `string` | n/a | yes |
| <a name="input_wg_iface"></a> [wg\_iface](#input\_wg\_iface) | Wireguard Interface | `string` | n/a | yes |
| <a name="input_worker_image"></a> [worker\_image](#input\_worker\_image) | Image for scw k3s worker instance | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Scaleway zone | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->