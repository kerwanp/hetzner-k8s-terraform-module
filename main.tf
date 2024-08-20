module "cluster" {
  source = "./modules/hcloud-cluster"

  name         = var.name
  cidr         = var.cidr
  hcloud_token = var.hcloud_token
  zone         = var.zone

  master = var.master
  agents = var.agents

  ssh_key = var.ssh_key
}

provider "kubernetes" {
  host                   = module.cluster.kubeconfig.host
  cluster_ca_certificate = module.cluster.kubeconfig.cluster_ca_certificate
  token                  = module.cluster.kubeconfig.token
}

provider "helm" {
  kubernetes {
    host                   = module.cluster.kubeconfig.host
    cluster_ca_certificate = module.cluster.kubeconfig.cluster_ca_certificate
    token                  = module.cluster.kubeconfig.token
  }
}

module "flannel" {
  source = "./modules/flannel"

  name          = try(var.flannel.name, null)
  namespace     = try(var.flannel.namespace, null)
  chart_version = try(var.flannel.chart_version, null)
  values        = try(var.flannel.values, [])
}

module "hcloud-ccm" {
  source = "./modules/hcloud-ccm"

  name          = try(var.ccm.name, null)
  namespace     = try(var.ccm.namespace, null)
  chart_version = try(var.ccm.chart_version, null)

  values = concat([yamlencode({
    env = {
      HCLOUD_NETWORK = {
        value = module.cluster.network_id
      }
      HCLOUD_NETWORK_ROUTES_ENABLED = {
        value = "false"
      }
      HCLOUD_LOAD_BALANCERS_LOCATION = {
        value = var.zone
      }
    }
  })], try(var.ccm.values, []))
}


module "hcloud-csi" {
  source = "./modules/hcloud-csi"

  name          = try(var.csi.name, null)
  namespace     = try(var.csi.namespace, null)
  chart_version = try(var.csi.chart_version, null)
  values        = try(var.csi.values, [])
}
