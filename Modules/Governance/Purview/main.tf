

resource "azurerm_purview_account" "purview" {
  name                = "${var.environment}-purview001"
  resource_group_name = var.rg_name
  location            = var.location
  sku_name            = "Standard_4"
  public_network_enabled = false
}
