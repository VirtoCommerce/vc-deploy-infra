resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
  location            = var.location
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  default_node_pool {
    name                = "primary"
    enable_auto_scaling = "true"
    max_count           = var.max_count
    min_count           = var.min_count
    vm_size             = var.vm_size
    availability_zones  = ["1", "2", "3"]
    node_count          = var.node_count
    vnet_subnet_id      = var.subnet_default
    max_pods            = var.max_pods
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    network_policy    = "calico"
  }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
    oms_agent {
      enabled = false
    }
  }

  tags = {
    Environment = "Production"
  }
}
resource "azurerm_kubernetes_cluster_node_pool" "app" {
  name                  = "applications"
  enable_auto_scaling   = "true"
  max_count             = "4"
  min_count             = "1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = "Standard_E2ds_v4"
  availability_zones    = ["1", "2", "3"]
  node_count            = "1"
  vnet_subnet_id        = var.subnet_default
  max_pods              = var.max_pods

  tags = {
    Environment = "Apps"
  }
}
