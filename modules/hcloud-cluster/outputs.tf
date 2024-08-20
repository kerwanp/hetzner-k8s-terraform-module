output "kubeconfig" {
  value = {
    content                = data.k8sbootstrap_auth.auth.kubeconfig
    host                   = local.kubeconfig.clusters[0].cluster.server
    cluster_ca_certificate = base64decode(local.kubeconfig.clusters[0].cluster.certificate-authority-data)
    token                  = local.kubeconfig.users[0].user.token
  }
  description = "Kubeconfig data. Can be used to access the cluster."
}

output "network_id" {
  value       = hcloud_network.this.id
  description = "ID of the created network"
}
