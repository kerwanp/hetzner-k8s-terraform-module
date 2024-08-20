variable "name" {
  type        = string
  description = "Chart release name"
  default     = "flannel"
}

variable "namespace" {
  type        = string
  description = "Namespace name that will be created"
  default     = "kube-flannel"
}

variable "chart_version" {
  type        = string
  description = "Chart version"
  default     = "0.25.5"
}

variable "values" {
  type        = list(string)
  description = "Chart values"
  default     = []
}
