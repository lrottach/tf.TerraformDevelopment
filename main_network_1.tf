resource "azurerm_resource_group" "rg-vnet-1" {
  name     = "rg-vnet-sn-001"
  location = var.resource_location
  tags = var.resource_tags
}

resource "azurerm_network_security_group" "nsg-gatewaysubnet-vnet-1" {
  name                  = "nsg-gatewaysubnet-vnet-sn-001"
  location              = azurerm_resource_group.rg-vnet-1.location
  resource_group_name   = azurerm_resource_group.rg-vnet-1.name
  tags = var.resource_tags
}

resource "azurerm_network_security_group" "nsg-bastionsubnet-vnet-1" {
  name                  = "nsg-bastionsubnet-vnet-sn-001"
  location              = azurerm_resource_group.rg-vnet-1.location
  resource_group_name   = azurerm_resource_group.rg-vnet-1.name
  tags = var.resource_tags

  security_rule {
    name                        = "bastion-in-allow"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "Internet"
    destination_address_prefix  = "*"
  }

  security_rule {
    name                        = "bastion-control-in-allow"
    priority                    = 120
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_ranges           = ["443", "4443"]
    destination_port_range      = "*"
    source_address_prefix       = "GatewayManager"
    destination_address_prefix  = "*"
  }

  security_rule {
    name                        = "bastion-in-deny"
    priority                    = 900
    direction                   = "Inbound"
    access                      = "Deny"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = "*"
    source_address_prefix       = "*"
    destination_address_prefix  = "VirtualNetwork"
  }

  security_rule {
    name                        = "bastion-vnet-out-allow"
    priority                    = 100
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_ranges      = ["22", "3389"]
    source_address_prefix       = "*"
    destination_address_prefix  = "VirtualNetwork"
  }

  security_rule {
    name                        = "bastion-azure-out-allow"
    priority                    = 120
    direction                   = "Outbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "*"
    destination_address_prefix  = "AzureCloud"
  }
}

resource "azurerm_network_security_group" "nsg-firewallsubnet-vnet-1" {
  name                  = "nsg-firewallsubnet-vnet-sn-001"
  location              = azurerm_resource_group.rg-vnet-1.location
  resource_group_name   = azurerm_resource_group.rg-vnet-1.name
  tags = var.resource_tags
}

resource "azurerm_network_security_group" "nsg-firewallpublicsubnet-vnet-1" {
  name                  = "nsg-firewallpublicsubnet-vnet-sn-001"
  location              = azurerm_resource_group.rg-vnet-1.location
  resource_group_name   = azurerm_resource_group.rg-vnet-1.name
  tags = var.resource_tags
}

resource "azurerm_network_security_group" "nsg-firewallmgmtsubnet-vnet-1" {
  name                  = "nsg-firewallpublicsubnet-vnet-sn-001"
  location              = azurerm_resource_group.rg-vnet-1.location
  resource_group_name   = azurerm_resource_group.rg-vnet-1.name
  tags = var.resource_tags
}

resource "azurerm_network_security_group" "nsg-applicationsubnet-vnet-1" {
  name                  = "nsg-applicationsubnet-vnet-sn-001"
  location              = azurerm_resource_group.rg-vnet-1.location
  resource_group_name   = azurerm_resource_group.rg-vnet-1.name
  tags = var.resource_tags
}

resource "azurerm_network_security_group" "nsg-managementsubnet-vnet-1" {
  name                  = "nsg-managementsubnet-vnet-sn-001"
  location              = azurerm_resource_group.rg-vnet-1.location
  resource_group_name   = azurerm_resource_group.rg-vnet-1.name
  tags = var.resource_tags
}

resource "azurerm_network_security_group" "nsg-servicessubnet-vnet-1" {
  name                  = "nsg-servicessubnet-vnet-sn-001"
  location              = azurerm_resource_group.rg-vnet-1.location
  resource_group_name   = azurerm_resource_group.rg-vnet-1.name
  tags = var.resource_tags
}

resource "azurerm_virtual_network" "vnet-1" {
  name                  = "vnet-sn-001"
  location              = azurerm_resource_group.rg-vnet-1.location
  resource_group_name   = azurerm_resource_group.rg-vnet-1.name
  address_space         = ["10.10.0.0/16"]
  tags = var.resource_tags

  subnet {
    name            = "GatewaySubnet"
    address_prefix  = "10.10.1.0/24"
    security_group  = azurerm_network_security_group.nsg-gatewaysubnet-vnet-1.id
  }

  subnet {
    name            = "BastionSubnet"
    address_prefix  = "10.10.2.0/24"
    security_group  = azurerm_network_security_group.nsg-bastionsubnet-vnet-1.id
  }

  subnet {
    name            = "FirewallSubnet"
    address_prefix  = "10.10.3.0/24"
    security_group  = azurerm_network_security_group.nsg-firewallsubnet-vnet-1.id
  }

  subnet {
    name            = "FirewallPublicSubnet"
    address_prefix  = "10.10.4.0/24"
    security_group  = azurerm_network_security_group.nsg-firewallpublicsubnet-vnet-1.id
  }

  subnet {
    name            = "FirewallManagementSubnet"
    address_prefix  = "10.10.5.0/24"
    security_group  = azurerm_network_security_group.nsg-firewallmgmtsubnet-vnet-1.id
  }

  subnet {
    name            = "ApplicationSubnet"
    address_prefix  = "10.10.6.0/24"
    security_group  = azurerm_network_security_group.nsg-applicationsubnet-vnet-1.id
  }

  subnet {
    name            = "ManagementSubnet"
    address_prefix  = "10.10.7.0/24"
    security_group  = azurerm_network_security_group.nsg-managementsubnet-vnet-1.id
  }

  subnet {
    name            = "ServicesSubnet"
    address_prefix  = "10.10.8.0/24"
    security_group  = azurerm_network_security_group.nsg-servicessubnet-vnet-1.id
  }  
}

resource "azurerm_virtual_network_peering" "peering-1-to-2" {
  name                        = "peering_vnet-1_vnet-2"
  resource_group_name         = azurerm_resource_group.rg-vnet-1.name
  virtual_network_name        = azurerm_virtual_network.vnet-1.name
  remote_virtual_network_id   = azurerm_virtual_network.vnet-2.name
}
