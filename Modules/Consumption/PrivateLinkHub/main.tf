locals {
  safe_name = replace(var.name, "-", "")
}

resource "azurerm_synapse_private_link_hub" "synapse_hub" {
  name                = "${local.safe_name}synapsehub001"
  resource_group_name = var.rg_name
  location            = var.location
}

resource "azurerm_private_endpoint" "synapse_hub_private_endpoint" {
  name                = "${azurerm_synapse_private_link_hub.synapse_hub.name}-synapse-hub-private-endpoint"
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.svc_subnet_id

  private_service_connection {
    name                           = "${azurerm_synapse_private_link_hub.synapse_hub.name}-synapse-hub-private-endpoint-connection"
    private_connection_resource_id = azurerm_synapse_private_link_hub.synapse_hub.id
    subresource_names              = ["web"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "private-dns-synapse-private-link-hub-portal-zone-group"
    private_dns_zone_ids = var.synapse_web_dns_zone_id
  }
}
