################################################################################
# secrets
################################################################################
resource "random_password" "cluster_token" {
  length  = 64
  special = false
}

resource "random_password" "bootstrap_token_id" {
  length  = 6
  upper   = false
  special = false
}

resource "random_password" "bootstrap_token_secret" {
  length  = 16
  upper   = false
  special = false
}

################################################################################
# data
################################################################################
data "hcloud_location" "this" {
  name = var.zone
}

locals {
  subnet = cidrsubnet(var.cidr, 8, 1)
  token  = "${random_password.bootstrap_token_id.result}.${random_password.bootstrap_token_secret.result}"
  k3s_master_args = [
    "server",
    "--cluster-init",
    "--kube-apiserver-arg", "enable-bootstrap-token-auth",
    "--kubelet-arg", "cloud-provider=external",
    "--disable", "traefik",
    "--disable-cloud-controller",
  ]
  k3s_agent_args = [
    "agent",
    "--kubelet-arg", "cloud-provider=external",
  ]
}

################################################################################
# network
################################################################################
resource "hcloud_network" "this" {
  name     = var.name
  ip_range = var.cidr
}

resource "hcloud_network_subnet" "this" {
  type         = "cloud"
  network_id   = hcloud_network.this.id
  network_zone = data.hcloud_location.this.network_zone
  ip_range     = local.subnet
}

################################################################################
# master
################################################################################
module "master" {
  source = "github.com/nimbolus/tf-k3s/k3s-hcloud"

  name         = "${var.name}-master"
  keypair_name = var.ssh_key

  network_id    = hcloud_network_subnet.this.network_id
  network_range = hcloud_network.this.ip_range

  cluster_token          = random_password.cluster_token.result
  k3s_args               = local.k3s_master_args
  bootstrap_token_id     = random_password.bootstrap_token_id.result
  bootstrap_token_secret = random_password.bootstrap_token_secret.result

  location    = data.hcloud_location.this.name
  server_type = var.master.server_type
}

################################################################################
# master
################################################################################
module "agents" {
  for_each = var.agents

  source = "github.com/nimbolus/tf-k3s/k3s-hcloud"

  name         = "${var.name}-${each.key}"
  keypair_name = var.ssh_key

  network_id    = hcloud_network_subnet.this.network_id
  network_range = hcloud_network.this.ip_range

  k3s_join_existing = true
  k3s_url           = module.master.k3s_url
  cluster_token     = random_password.cluster_token.result
  k3s_args          = local.k3s_agent_args

  location    = data.hcloud_location.this.name
  server_type = each.value.server_type
}


################################################################################
# cluster access
################################################################################
data "k8sbootstrap_auth" "auth" {
  server = module.master.k3s_external_url
  token  = local.token
}

locals {
  kubeconfig = yamldecode(data.k8sbootstrap_auth.auth.kubeconfig)

  cluster_access = {
    host                   = local.kubeconfig.clusters[0].cluster.server
    cluster_ca_certificate = base64decode(local.kubeconfig.clusters[0].cluster.certificate-authority-data)
    token                  = local.kubeconfig.users[0].user.token
  }
}

provider "kubernetes" {
  host                   = local.cluster_access.host
  cluster_ca_certificate = local.cluster_access.cluster_ca_certificate
  token                  = local.cluster_access.token
}

resource "kubernetes_secret" "hcloud" {
  metadata {
    name      = "hcloud"
    namespace = "kube-system"
  }

  data = {
    token   = var.hcloud_token
    network = hcloud_network.this.id
  }
}
