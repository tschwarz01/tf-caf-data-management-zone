resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name}nsg"
  location            = var.location
  resource_group_name = var.rg_name

  tags = var.tags
}
