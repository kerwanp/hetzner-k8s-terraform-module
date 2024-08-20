# Hetzner Kubernetes Terraform Module

This Terraform module allows you to bootstrap self-managed clusters on Hetzner Cloud in no time. Perfect for labs.

> ⚠ This is not battle tested, use it are your own risks.

## Features

- ✅ Cheap nodes thanks to [Hetzner Cloud](https://www.hetzner.com/) pricing
- ✅ Automatically creates and joins new nodes
- ✅ Manages Persistent volume claims by using Hetzner [Cloud Storage Interface driver](https://github.com/hetznercloud/csi-driver)
- ✅ Manages Load balancer by using Hetzner [Cloud Controller Manager](https://github.com/hetznercloud/hcloud-cloud-controller-manager)

<!-- BEGIN_TF_DOCS -->

## Example

```hcl
provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "personal" {
  name       = "Personal"
  public_key = file("~/.ssh/id_ed25519.pub")
}

module "cluster" {
  source = "../"

  name    = "my-cluster"
  ssh_key = hcloud_ssh_key.personal.id

  hcloud_token = var.hcloud_token

  cidr = "10.0.0.0/16"
  zone = "nbg1"

  master = {
    server_type = "cpx21"
  }

  agents = {
    0 = {
      server_type = "cpx21"
    }
  }
}

resource "local_sensitive_file" "kubeconfig" {
  content  = module.cluster.kubeconfig.content
  filename = "kubeconfig.yaml"
}
```

## Inputs

| Name                                                                  | Description                                              | Type                                                     | Default | Required |
| --------------------------------------------------------------------- | -------------------------------------------------------- | -------------------------------------------------------- | ------- | :------: |
| <a name="input_agents"></a> [agents](#input_agents)                   | Map of agents configurations                             | <pre>map(object({<br> server_type = string<br> }))</pre> | `{}`    |    no    |
| <a name="input_ccm"></a> [ccm](#input_ccm)                            | Hetzner Cloud Controller Manager configuration           | `any`                                                    | `null`  |    no    |
| <a name="input_cidr"></a> [cidr](#input_cidr)                         | IP addresses range for the private network               | `string`                                                 | n/a     |   yes    |
| <a name="input_csi"></a> [csi](#input_csi)                            | Hetzner Container Storage Interface configuration        | `any`                                                    | `null`  |    no    |
| <a name="input_flannel"></a> [flannel](#input_flannel)                | Flannel configuration                                    | `any`                                                    | `null`  |    no    |
| <a name="input_hcloud_token"></a> [hcloud_token](#input_hcloud_token) | The Hetzner Cloud API token                              | `string`                                                 | n/a     |   yes    |
| <a name="input_master"></a> [master](#input_master)                   | Master configuration                                     | <pre>object({<br> server_type = string<br> })</pre>      | n/a     |   yes    |
| <a name="input_name"></a> [name](#input_name)                         | The name of the cluster used to prefix resources         | `string`                                                 | n/a     |   yes    |
| <a name="input_ssh_key"></a> [ssh_key](#input_ssh_key)                | SSH Key ID or name that will be added to created servers | `string`                                                 | n/a     |   yes    |
| <a name="input_zone"></a> [zone](#input_zone)                         | Zone where resources will be created                     | `string`                                                 | n/a     |   yes    |

## Outputs

| Name                                                              | Description |
| ----------------------------------------------------------------- | ----------- |
| <a name="output_kubeconfig"></a> [kubeconfig](#output_kubeconfig) | n/a         |

<!-- END_TF_DOCS -->
