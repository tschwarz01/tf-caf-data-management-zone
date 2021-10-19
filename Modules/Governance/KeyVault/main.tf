
resource "azurerm_key_vault" "key_vault" {
  name                            = "${var.environment}-vault001"
  location                        = var.location
  resource_group_name             = var.rg_name
  tenant_id                       = var.tenant_id
  soft_delete_retention_days      = 7
  enabled_for_disk_encryption     = false
  purge_protection_enabled        = true
  enabled_for_template_deployment = false
  enabled_for_deployment          = false
  enable_rbac_authorization       = true
  sku_name                        = "standard"
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
}


# KeyVault Private Link
resource "azurerm_private_endpoint" "keyvault_private_endpoint" {
  name                = "${azurerm_key_vault.key_vault.name}-keyvault-private-endpoint"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.svc_subnet_id

  private_service_connection {
    name                           = "${azurerm_key_vault.key_vault.name}-keyvault-private-endpoint-connection"
    private_connection_resource_id = azurerm_key_vault.key_vault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = var.keyvault_dns_zone_id
  }
}
