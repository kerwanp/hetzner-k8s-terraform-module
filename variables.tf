variable "hcloud_token" {
  type        = string
  description = "The Hetzner Cloud API token"
  sensitive   = true
}

variable "ssh_key" {
  type        = string
  description = "SSH Key ID or name that will be added to created servers"
  nullable    = true
}

variable "name" {
  type        = string
  description = "The name of the cluster used to prefix resources"
}

variable "cidr" {
  type        = string
  description = "IP addresses range for the private network"
}

variable "zone" {
  type        = string
  description = "Zone where resources will be created"
}

variable "master" {
  type = object({
    server_type = string
  })

  description = "Master configuration"
}

variable "agents" {
  type = map(object({
    server_type = string
  }))

  description = "Map of agents configurations"
  default     = {}
}

variable "flannel" {
  type        = any
  description = "Flannel configuration"
  default     = null
}

variable "ccm" {
  type        = any
  description = "Hetzner Cloud Controller Manager configuration"
  default     = null
}

variable "csi" {
  type        = any
  description = "Hetzner Container Storage Interface configuration"
  default     = null
}
