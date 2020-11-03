resource "azurerm_resource_group" "rg-vnet-2" {
  name     = "rg-vnet-sn-002"
  location = var.resource_location
}