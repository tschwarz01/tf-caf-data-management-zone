resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name}-network"
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "firewall_subnet" {
  name                                           = "AzureFirewallSubnet"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [var.firewall_address_space]
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet" "services_subnet" {
  name                                           = "${var.environment}-services-subnet"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [var.services_address_space]
  enforce_private_link_endpoint_network_policies = true
  enforce_private_link_service_network_policies  = true
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_subnet" "gateway_subnet" {
  name                                           = "GatewaySubnet"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = [var.gateway_address_space]
  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_route_table" "route_table" {
  name                          = "${var.environment}-route-table"
  location                      = var.location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = false

  route {
    name                   = "to-firewall-default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

resource "azurerm_public_ip" "vnet-gw-pip" {
  name                = "${var.name}-gw-pip"
  location            = var.location
  resource_group_name = var.rg_name

  allocation_method = "Dynamic"
  depends_on = [
    azurerm_subnet.gateway_subnet
  ]
}

resource "azurerm_virtual_network_gateway" "vnet_gateway" {
  name                = "${var.name}-vnet-gw"
  location            = var.location
  resource_group_name = var.rg_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vnet-gw-pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }

  vpn_client_configuration {
    address_space = [var.vpn_client_address_space]

    root_certificate {
      name = "P2SRootCert"

      public_cert_data = var.vnet_gateway_public_cert
    }
  }
}

resource "azurerm_subnet_route_table_association" "rt_tbl_assoc" {
  subnet_id      = azurerm_subnet.services_subnet.id
  route_table_id = azurerm_route_table.route_table.id
  depends_on = [
    azurerm_subnet.services_subnet
  ]
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet_services_assoc" {
  subnet_id                 = azurerm_subnet.services_subnet.id
  network_security_group_id = var.nsg_id
  depends_on = [
    azurerm_subnet.services_subnet,
    var.nsg_id
  ]
}
