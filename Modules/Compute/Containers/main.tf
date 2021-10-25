resource "azurerm_container_registry" "acr" {
  name                          = "${var.environment}containerregistry001"
  resource_group_name           = var.rg_name
  location                      = var.location
  sku                           = "Premium"
  public_network_access_enabled = false
  quarantine_policy_enabled     = true
  admin_enabled                 = false
  identity {
    type = "SystemAssigned"
  }
  retention_policy = [{
    days    = 7
    enabled = true
  }]
  trust_policy = [{
    enabled = false
  }]
}

resource "azurerm_private_endpoint" "acr_private_endpoint" {
  name                = "${azurerm_container_registry.acr.name}-acr-private-endpoint"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.svc_subnet_id

  private_service_connection {
    name                           = "${azurerm_container_registry.acr.name}-acr-private-endpoint-connection"
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-acr-zone-group"
    private_dns_zone_ids = var.acr_dns_zone_id
  }
  depends_on = [
    azurerm_container_registry.acr
  ]
}
