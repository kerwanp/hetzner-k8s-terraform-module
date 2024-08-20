resource "helm_release" "hcloud-cloud-controller-manager" {
  namespace  = coalesce(var.namespace, "kube-system")
  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-cloud-controller-manager"
  name       = coalesce(var.name, "hcloud-ccm")
  version    = coalesce(var.chart_version, "1.20.0")

  values = var.values
}
