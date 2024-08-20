resource "kubernetes_namespace" "flannel" {
  metadata {
    name = coalesce(var.namespace, "kube-flannel")
    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

resource "helm_release" "this" {
  namespace = kubernetes_namespace.flannel.metadata[0].name

  repository = "https://flannel-io.github.io/flannel/"
  chart      = "flannel"
  name       = coalesce(var.name, "flannel")
  version    = coalesce(var.chart_version, "0.25.5")

  values = concat([
    yamlencode({
      podCidr = "10.42.0.0/16"
      flannel = {
        tolerations = [
          {
            effect   = "NoExecute"
            operator = "Exists"
          },
          {
            effect   = "NoSchedule"
            operator = "Exists"
          },
          {
            effect = "NoSchedule"
            key    = "node.cloudprovider.kubernetes.io/uninitialized"
            value  = "true"
          }
        ]
      }
    })
  ], var.values)
}
