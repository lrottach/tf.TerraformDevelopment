resource "azurerm_resource_group" "rg-vnet-2" {
  name     = "rg-vnet-sn-002"
  location = var.resource_location
  tags = var.resource_tags
}

resource "azurerm_network_security_group" "nsg-gatewaysubnet-vnet-2" {
  name                  = "nsg-gatewaysubnet-vnet-sn-002"
  location              = azurerm_resource_group.rg-vnet-2.location
  resource_group_name   = azurerm_resource_group.rg-vnet-2.name
  tags = var.resource_tags
}

resource "azurerm_network_security_group" "nsg-bastionsubnet-vnet-2" {
  name                  = "nsg-bastionsubnet-vnet-sn-002"
  location              = azurerm_resource_group.rg-vnet-2.location
  resource_group_name   = azurerm_resource_group.rg-vnet-2.name
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

resource "azurerm_network_security_group" "nsg-serversubnet-vnet-2" {
  name                  = "nsg-serversubnet-vnet-sn-002"
  location              = azurerm_resource_group.rg-vnet-2.location
  resource_group_name   = azurerm_resource_group.rg-vnet-2.name
  tags = var.resource_tags
}

resource "azurerm_virtual_network" "vnet-2" {
  name                  = "vnet-sn-002"
  location              = azurerm_resource_group.rg-vnet-2.location
  resource_group_name   = azurerm_resource_group.rg-vnet-2.name
  address_space         = ["10.11.0.0/16"]
  tags = var.resource_tags

  subnet {
    name            = "GatewaySubnet"
    address_prefix  = "10.11.1.0/24"
    security_group  = azurerm_network_security_group.nsg-gatewaysubnet-vnet-2.id
  }

  subnet {
    name            = "Serversubnet"
    address_prefix  = "10.11.3.0/24"
    security_group  = azurerm_network_security_group.nsg-serversubnet-vnet-2.id
  }
}

resource "azurerm_virtual_network_peering" "peering-2-to-1" {
  name                        = "peering_vnet-2_vnet-1"
  resource_group_name         = azurerm_resource_group.rg-vnet-2.name
  virtual_network_name        = azurerm_virtual_network.vnet-2.name
  remote_virtual_network_id   = azurerm_virtual_network.vnet-1.name
  allow_forwarded_traffic = true
  allow_virtual_network_access = true
} 

// Azure Bastion deployment

resource "azurerm_subnet" "bastion-subnet-vnet-2" {
  name = "AzureBastionSubnet"
  resource_group_name = azurerm_resource_group.rg-vnet-2.name
  address_prefixes = ["10.11.2.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet-2.name
}

resource "azurerm_public_ip" "bastion-pip-vnet-2" {
  name                        = "pip-bastion-vnet-sn-002"
  location                    = azurerm_resource_group.rg-vnet-2.location
  resource_group_name         = azurerm_resource_group.rg-vnet-2.name
  allocation_method         = "Static"
  sku                       = "Standard"
  tags = var.resource_tags
}

resource "azurerm_bastion_host" "bastion-vnet-2" {
  name                      = "bastion-vnet-sn-002"
  location                  = azurerm_resource_group.rg-vnet-2.location
  resource_group_name       = azurerm_resource_group.rg-vnet-2.name
  tags = var.resource_tags

  ip_configuration {
    name = "IpConf"
    subnet_id = azurerm_subnet.bastion-subnet-vnet-2.id
    public_ip_address_id = azurerm_public_ip.bastion-pip-vnet-2.id
  }
}