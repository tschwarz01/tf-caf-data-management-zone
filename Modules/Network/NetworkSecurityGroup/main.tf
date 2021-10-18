resource "azurerm_network_security_group" "dmz_nsg" {
  name                = "${var.environment}nsg"
  location            = var.location
  resource_group_name = var.rg_name

  tags = {
    environment = var.environment
  }
}
