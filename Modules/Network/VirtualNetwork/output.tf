output "firewall_subnet_id_out" {
  value = azurerm_subnet.firewall_subnet.id
}

output "services_subnet_id_out" {
  value = azurerm_subnet.services_subnet.id
}

output "datamz_vnet_id_out" {
  value = azurerm_virtual_network.vnet.id
}

output "datamz_vnet_name_out" {
  value = azurerm_virtual_network.vnet.name
}


output "networking-output" {
  value = {
    firewall_subnet_id_out = azurerm_subnet.firewall_subnet.id
    services_subnet_id_out = azurerm_subnet.services_subnet.id
    datamz_vnet_id_out     = azurerm_virtual_network.vnet.id
    datamz_vnet_name_out   = azurerm_virtual_network.vnet.name
  }

}
