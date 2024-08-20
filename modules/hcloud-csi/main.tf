resource "helm_release" "hcloud-cloud-controller-manager" {
  namespace  = coalesce(var.namespace, "kube-system")
  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-csi"
  name       = coalesce(var.name, "hcloud-csi")
  # version    = coalesce(var.chart_version, "1.20.0")

  values = var.values
}
