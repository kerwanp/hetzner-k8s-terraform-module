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
