/*
output "purview-output" {
  value = azurerm_purview_account.purview
}
*/

output "purview-identity" {
  value = azurerm_purview_account.purview.identity
}

output "purview-output" {
  value = {
    catalog_endpoint    = azurerm_purview_account.purview.catalog_endpoint
    guardian_endpoint   = azurerm_purview_account.purview.guardian_endpoint
    id                  = azurerm_purview_account.purview.id
    identity            = azurerm_purview_account.purview.identity
    location            = azurerm_purview_account.purview.location
    name                = azurerm_purview_account.purview.name
    resource_group_name = azurerm_purview_account.purview.resource_group_name
    scan_endpoint       = azurerm_purview_account.purview.scan_endpoint
  }
}
