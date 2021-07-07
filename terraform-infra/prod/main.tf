provider "azurerm" {
  version = "~>2.0"

  subscription_id = var.subscription_id
  client_id       = var.service_principal_client_id
  client_secret   = var.service_principal_client_secret
  tenant_id       = var.tenant_id

  features {}
}

terraform {
  backend "azurerm" {}
}

resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "../modules/network"
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
}

# module "dns" {
#   source   = "../modules/dns"
#   location = var.location
# }

module "sql" {
  source = "../modules/sql"

  name                = "prod"
  db_login            = "virto"
  db_password         = var.db_password
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  ad_tenant_id        = var.ad_tenant_id // VirtoWay AD
  ad_object_id        = var.ad_object_id // VirtoCommerce Users
}

module "k8s" {
  source              = "../modules/k8s"
  cluster_name        = "vc-master"
  client_id           = var.service_principal_client_id
  client_secret       = var.service_principal_client_secret
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  max_count           = "4"
  min_count           = "4"
  vm_size             = "Standard_D2ds_v4"
  subnet_default      = module.network.subnet1
  dns_prefix          = var.dns_prefix
  node_count          = "4"
  max_pods            = "120"
  subnet_2            = module.network.subnet2
}