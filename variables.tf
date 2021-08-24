# Module variables
variable "resource_group_name" {
    type = string
    description = "(Required) Target resource group"
}

variable "identity_name" {
  type = string
  description = "(Required) Identity name"
}

# AKS variables
variable "aks_name" {
    type = string
    description = "(Required) AKS cluster name"
}

variable "aks_dns_prefix" {
    type = string
    description = "(Required) AKS DNS prefix"
}

variable "aks_pool_name" {
  type = string
  description = "(Optional) AKS node pool name. Default is aks_pool"
  default = "aks_pool"
}

variable "aks_node_size" {
  type = string
  description = "(Optional) AKS node size. Default is Standard_D2s_v3"
  default = "Standard_D2s_v3"
}

variable "aks_node_count" {
  type = number
  description = "(Required) AKS node count. Default is 1"
  default = 1
}

variable "private_cluster_enabled" {
    type = bool
    description = "(Optional) Enable private cluster"
    default = true
}

# Misc
variable "project_tag" {
    type = string
    description = "(Required) Project tag"
}