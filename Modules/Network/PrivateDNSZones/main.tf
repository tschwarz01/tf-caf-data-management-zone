/*
resource "azurerm_resource_group" "rg_dmz_private_dns_zones" {
  name     = "rg-dmz-private-dns-zones"
  location = "southcentralus"
  tags = {
    "Usage" = "Azure Private DNS Zones for Private Endpoints"
  }
}
*/

resource "azurerm_private_dns_zone" "privlink_dns_zones" {
  for_each            = var.dns_zones
  name                = each.value
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_links" {
  for_each              = azurerm_private_dns_zone.privlink_dns_zones
  name                  = "${each.value.name}/${var.vnet_name}"
  resource_group_name   = var.rg_name
  private_dns_zone_name = each.value.name
  virtual_network_id    = var.vnet_id
}
