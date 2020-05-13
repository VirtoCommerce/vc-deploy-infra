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
  service_principal_client_id     = var.service_principal_client_id
  service_principal_client_secret = var.service_principal_client_secret
}

output "kubeconfig_dev" {
  value = module.dev.kube_config
}