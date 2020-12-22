resource "azurerm_virtual_network" "net1" {
  name                = "main-network"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "akssubnet1"
  virtual_network_name = azurerm_virtual_network.net1.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.1.0.0/16"]
}
resource "azurerm_subnet" "subnet2" {
  name                 = "akssubnet2"
  virtual_network_name = azurerm_virtual_network.net1.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.2.0.0/16"]
}
resource "azurerm_subnet" "subnet3" {
  name                 = "akssubnet3"
  virtual_network_name = azurerm_virtual_network.net1.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.3.0.0/16"]
}