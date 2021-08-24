terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
  }
}

data "azurerm_resource_group" "rsg" {
  name = var.resource_group_name
}

# DNS Zone
resource "azurerm_private_dns_zone" "dns_zone" {
    name = "privatelink.westeurope.aks.io"
    resource_group_name = data.azurerm_resource_group.rsg.name
}


resource "azurerm_user_assigned_identity" "identity" {
  name                = var.identity_name
  resource_group_name = data.azurerm_resource_group.rsg.name
  location            = data.azurerm_resource_group.rsg.location
}

resource "azurerm_role_assignment" "role" {
    scope = azurerm_private_dns_zone.dns_zone.id
    role_definition_name = "Private DNS Zone Contributor"
    principal_id = azurerm_user_assigned_identity.identity.principal_id
}

# AKS Cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
    name = var.aks_name
    location = data.azurerm_resource_group.rsg.location
    resource_group_name = data.azurerm_resource_group.rsg.name
    dns_prefix = var.aks_dns_prefix
    private_cluster_enabled = var.private_cluster_enabled
    private_dns_zone_id = azurerm_private_dns_zone.dns_zone.id

    default_node_pool {
        name       = var.aks_pool_name
        node_count = var.aks_node_count
        vm_size    = var.aks_node_size
    }

    identity {
      type = "SystemAssigned"
    }

    tags = {
      project = var.project_tag
    }

    depends_on = [
      azurerm_role_assignment.role
    ]

}

