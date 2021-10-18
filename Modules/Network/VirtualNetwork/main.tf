resource "azurerm_virtual_network" "dmz_vnet" {
  name                = "${var.environment}-network"
  address_space       = ["10.0.0.0/21"]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "dmz_firewall_subnet" {
  name                                           = "${var.environment}-firewall-subnet"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = azurerm_virtual_network.dmz_vnet.name
  address_prefixes                               = ["10.0.0.0/24"]
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
  depends_on = [
    azurerm_virtual_network.dmz_vnet
  ]
}

resource "azurerm_subnet" "dmz_services_subnet" {
  name                                           = "${var.environment}-services-subnet"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = azurerm_virtual_network.dmz_vnet.name
  address_prefixes                               = ["10.0.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
  depends_on = [
    azurerm_virtual_network.dmz_vnet
  ]
}

resource "azurerm_route_table" "dmz_route_table" {
  name                          = "${var.environment}-route-table"
  location                      = var.location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = false

  route {
    name                   = "to-firewall-default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.0.4"
  }
}

resource "azurerm_subnet_route_table_association" "dmz_rt_tbl_assoc" {
  subnet_id      = azurerm_subnet.dmz_services_subnet.id
  route_table_id = azurerm_route_table.dmz_route_table.id
  depends_on = [
    azurerm_subnet.dmz_services_subnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "dmz_nsg_subnet_services_assoc" {
  subnet_id                 = azurerm_subnet.dmz_services_subnet.id
  network_security_group_id = var.nsg_id
  depends_on = [
    azurerm_subnet.dmz_services_subnet,
    var.nsg_id
  ]
}
