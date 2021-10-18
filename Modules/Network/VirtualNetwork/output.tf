output "firewall_subnet_id_out" {
  value = azurerm_subnet.dmz_firewall_subnet.id
}

output "services_subnet_id_out" {
  value = azurerm_subnet.dmz_services_subnet.id
}

output "dmz_vnet_id_out" {
  value = azurerm_virtual_network.dmz_vnet.id
}

output "dmz_vnet_name_out" {
  value = azurerm_virtual_network.dmz_vnet.name
}
