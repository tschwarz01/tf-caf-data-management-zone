output "priv-dns-zones" {
  value = azurerm_private_dns_zone.privlink_dns_zones
}
/*

output "test-out" {
  value = azurerm_private_dns_zone.privlink_dns_zones["privatelink.dfs.core.windows.net"].id
}

*/
