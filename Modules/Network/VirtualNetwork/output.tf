output "firewall_subnet_id_out" {
  value = azurerm_subnet.firewall_subnet.id
}

output "services_subnet_id_out" {
  value = azurerm_subnet.services_subnet.id
}

output "fxdatamz_vnet_id_out" {
  value = azurerm_virtual_network.vnet.id
}

output "fxdatamz_vnet_name_out" {
  value = azurerm_virtual_network.vnet.name
}
