variable "name" {
  type        = string
  description = "Chart release name"
  default     = "hcloud-ccm"
}

variable "namespace" {
  type        = string
  description = "Namespace where the chart will be released"
  default     = "kube-system"
}

variable "chart_version" {
  type        = string
  description = "Chart version"
  default     = "1.20.0"
}

variable "values" {
  type        = list(string)
  description = "Chart values"
  default     = []
}
