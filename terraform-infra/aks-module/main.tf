provider "azurerm" {
    version = "~>2.0"
    features {}
}

variable "service_principal_client_id" {
  description = "The Client ID for the Service Principal"
}

variable "service_principal_client_secret" {
  description = "The Client Secret for the Service Principal"
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "name" {}

variable location {
    default = "westus"
}

resource "azurerm_resource_group" "rg" {
  name     = "aks-cluster-${var.name}"
  location = var.location
}

variable log_analytics_workspace_name {
    default = "testLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "eastus"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}

resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}

resource "azurerm_log_analytics_workspace" "test" {
    # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
    name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
    location            = var.log_analytics_workspace_location
    resource_group_name = azurerm_resource_group.rg.name
    sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "test" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.test.location
    resource_group_name   = azurerm_resource_group.rg.name
    workspace_resource_id = azurerm_log_analytics_workspace.test.id
    workspace_name        = azurerm_log_analytics_workspace.test.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

resource "azurerm_kubernetes_cluster" "cluster" {
  name       = "aks-${var.name}"
  location   = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix = "aks"

  linux_profile {
    admin_username = "ubuntu"
      ssh_key {
        key_data = file(var.ssh_public_key)
      }
  }

  default_node_pool {
      name           = "agentpool"
      node_count     = 1
      vm_size        = "Standard_D2s_v3"
  }  

  service_principal {
    client_id     = var.service_principal_client_id
    client_secret = var.service_principal_client_secret
  }


  addon_profile {
    oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.test.id
      }
  }  
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.cluster.kube_config_raw
}
