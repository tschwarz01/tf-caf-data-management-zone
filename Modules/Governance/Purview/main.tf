# The ingestion endpoints are currently not configurable w/ Private Endpoints via Terraform

resource "azurerm_purview_account" "purview" {
  name                   = "${var.name}-purview001"
  resource_group_name    = var.rg_name
  location               = var.location
  sku_name               = "Standard_4"
  public_network_enabled = false
}


resource "azurerm_private_endpoint" "purview_account_private_endpoint" {
  name                = "${azurerm_purview_account.purview.name}-purview-account-private-endpoint"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.svc_subnet_id

  private_service_connection {
    name                           = "${azurerm_purview_account.purview.name}-purview-account-private-endpoint-connection"
    private_connection_resource_id = azurerm_purview_account.purview.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-purview-account-zone-group"
    private_dns_zone_ids = var.purview_account_dns_zone_id
  }
  depends_on = [
    azurerm_purview_account.purview
  ]
}

resource "azurerm_private_endpoint" "purview_portal_private_endpoint" {
  name                = "${azurerm_purview_account.purview.name}-purview-portal-private-endpoint"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.svc_subnet_id

  private_service_connection {
    name                           = "${azurerm_purview_account.purview.name}-purview-portal-private-endpoint-connection"
    private_connection_resource_id = azurerm_purview_account.purview.id
    subresource_names              = ["portal"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-purview-portal-zone-group"
    private_dns_zone_ids = var.purview_portal_dns_zone_id
  }
  depends_on = [
    azurerm_purview_account.purview,
    azurerm_private_endpoint.purview_account_private_endpoint
  ]
}

resource "azurerm_role_assignment" "purview_keyvault_role_assignment" {
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_purview_account.purview.identity[0].principal_id
  depends_on = [
    azurerm_purview_account.purview
  ]
}
