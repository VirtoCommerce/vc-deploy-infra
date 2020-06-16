provider "azurerm" {
    version = "~>2.0"
    features {}
}

terraform {
    backend "azurerm" {}
}

variable "service_principal_client_id" {
  description = "The Client ID for the Service Principal"
}

variable "service_principal_client_secret" {
  description = "The Client Secret for the Service Principal"
}

variable db_password {
  description = "SQL Server Password"
}

module "dev" {
  source = "./aks-module"

  name                            = "dev"
  db_login                        = "virto"
  db_password                     = var.db_password
  node_count                      = 3
  vm_size                         = "Standard_B2ms"
  service_principal_client_id     = var.service_principal_client_id
  service_principal_client_secret = var.service_principal_client_secret
  ad_tenant_id                    = "bc03e660-5e3a-45c4-bf5c-b75489f78923" // VirtoWay AD
  ad_object_id                    = "d1de67d4-8536-4a12-b22d-ae3545be199e" // VirtoCommerce Users
}

output "kubeconfig_dev" {
  value = module.dev.kube_config
}