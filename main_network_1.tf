resource "azurerm_resource_group" "rg-vnet-1" {
  name     = "rg-vnet-sn-001"
  location = var.resource_location
}
