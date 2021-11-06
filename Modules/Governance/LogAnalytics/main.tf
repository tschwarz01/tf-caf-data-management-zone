resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.name}-log-analytics-ws"
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


