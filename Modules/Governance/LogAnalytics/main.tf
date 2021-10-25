data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg_monitoring" {
  name     = var.rg_name
  location = var.location
}
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.environment}-log-analytics-ws"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_monitoring.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  depends_on = [
    azurerm_resource_group.rg_monitoring
  ]
}


