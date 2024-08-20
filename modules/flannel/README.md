<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.15.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.32.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Chart version | `string` | `"0.25.5"` | no |
| <a name="input_name"></a> [name](#input\_name) | Chart release name | `string` | `"flannel"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace name that will be created | `string` | `"kube-flannel"` | no |
| <a name="input_values"></a> [values](#input\_values) | Chart values | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->