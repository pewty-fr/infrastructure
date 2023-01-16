<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.3 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement\_scaleway) | 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.3 |
| <a name="provider_scaleway"></a> [scaleway](#provider\_scaleway) | 2.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_instance_pool"></a> [instance\_pool](#module\_instance\_pool) | ../_common/instance-pool | n/a |

## Resources

| Name | Type |
|------|------|
| [random_password.k3s_password](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [random_password.vpn_password](https://registry.terraform.io/providers/hashicorp/random/3.4.3/docs/resources/password) | resource |
| [scaleway_rdb_database.k3s](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/resources/rdb_database) | resource |
| [scaleway_rdb_database.vpn](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/resources/rdb_database) | resource |
| [scaleway_rdb_instance.pewty](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/resources/rdb_instance) | resource |
| [scaleway_rdb_privilege.k3s](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/resources/rdb_privilege) | resource |
| [scaleway_rdb_privilege.vpn](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/resources/rdb_privilege) | resource |
| [scaleway_rdb_user.k3s_admin](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/resources/rdb_user) | resource |
| [scaleway_rdb_user.vpn_admin](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/resources/rdb_user) | resource |
| [scaleway_account_project.by_project_id](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/data-sources/account_project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pool"></a> [pool](#input\_pool) | description | <pre>object({<br>    ip      = string<br>    netmask = string<br>    db = map(object({<br>      ip = string<br>    }))<br>    vpn = map(object({<br>      ip = string<br>    }))<br>    k3s_master = map(object({<br>      ip = string<br>    }))<br>    k3s_worker = map(object({<br>      ip = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_private_network_id"></a> [private\_network\_id](#input\_private\_network\_id) | ID of the private network | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Scaleway project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Scaleway region | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Scaleway zone | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_k3s"></a> [db\_k3s](#output\_db\_k3s) | description |
| <a name="output_db_vpn"></a> [db\_vpn](#output\_db\_vpn) | description |
<!-- END_TF_DOCS -->