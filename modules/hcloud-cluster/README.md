<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | >= 1.48.0 |
| <a name="provider_k8sbootstrap"></a> [k8sbootstrap](#provider\_k8sbootstrap) | >= 0.1.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.32.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agents"></a> [agents](#input\_agents) | Map of agents configurations | <pre>map(object({<br>    server_type = string<br>  }))</pre> | `{}` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | IP addresses range for the private network | `string` | n/a | yes |
| <a name="input_hcloud_token"></a> [hcloud\_token](#input\_hcloud\_token) | The Hetzner Cloud API token | `string` | n/a | yes |
| <a name="input_master"></a> [master](#input\_master) | Master configuration | <pre>object({<br>    server_type = string<br>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the cluster used to prefix resources | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | SSH Key ID or name that will be added to created servers | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | HCloud zone where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Kubeconfig data. Can be used to access the cluster. |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | ID of the created network |
<!-- END_TF_DOCS -->