resource "azurerm_resource_group" "main" {
  name     = "rg-bastion-recording-test"
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-bastion-recording-test"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "vm" {
  name                 = "VMSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.1.1.0/26"]
}
