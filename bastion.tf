resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion-recording-test"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bas-bastion-recording-test"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}
