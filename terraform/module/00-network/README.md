<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement\_scaleway) | 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_scaleway"></a> [scaleway](#provider\_scaleway) | 2.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [scaleway_vpc_private_network.default](https://registry.terraform.io/providers/scaleway/scaleway/2.8.0/docs/resources/vpc_private_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | Scaleway project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Scaleway region | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Scaleway zone | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_network_id"></a> [private\_network\_id](#output\_private\_network\_id) | ID of the private network |
<!-- END_TF_DOCS -->