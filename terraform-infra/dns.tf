resource "azurerm_dns_zone" "govirto-public" {
  name                = "govirto.com"
  resource_group_name = azurerm_resource_group.rg.name
}