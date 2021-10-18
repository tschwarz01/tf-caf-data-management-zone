resource "azurerm_private_dns_zone" "privlink_dns_zones" {
  for_each            = var.dns_zones
  name                = each.value
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet-link-ex" {
  for_each              = azurerm_private_dns_zone.privlink_dns_zones
  name                  = "${each.value.name}-${var.vnet_name}-vnetlink"
  resource_group_name   = var.rg_name
  private_dns_zone_name = each.value.name
  virtual_network_id    = var.vnet_id
  depends_on = [
    azurerm_private_dns_zone.privlink_dns_zones
  ]
}
