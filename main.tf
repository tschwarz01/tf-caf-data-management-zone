# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  backend "azurerm" {
    subscription_id      = "47f7e6d7-0e52-4394-92cb-5f106bbc647f"
    tenant_id            = "72f988bf-86f1-41af-91ab-2d7cd011db47"
    resource_group_name  = "rg-data-management-zone-terraform"
    storage_account_name = "stgdatamgmtzoneterraform"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

/*
data "azurerm_resource_group" "rg_tf" {
  name = "rg-data-management-zone-terraform"
}
*/

resource "azurerm_resource_group" "rg_automation" {
  name     = local.automation-resource-group
  location = var.location
}

resource "azurerm_resource_group" "rg_mgmt" {
  name     = local.management-resource-group
  location = var.location
}





resource "azurerm_resource_group" "rg_networking" {
  name     = local.network-resource-group
  location = var.location
}

module "netsecgroup" {
  source   = "./Modules/Network/NetworkSecurityGroup"
  rg_name  = azurerm_resource_group.rg_networking.name
  location = var.location
  name     = local.name
  tags     = var.tags
}

module "networking" {
  source   = "./Modules/Network/VirtualNetwork"
  rg_name  = azurerm_resource_group.rg_networking.name
  location = var.location
  name     = local.name
  tags     = var.tags

  nsg_id                   = module.netsecgroup.id_out
  vnet_address_space       = var.vnet_address_space
  firewall_address_space   = var.firewall_subnet_address_space
  services_address_space   = var.services_subnet_address_space
  gateway_address_space    = var.gateway_subnet_address_space
  vpn_client_address_space = var.vpn_client_address_space
  vnet_gateway_public_cert = var.vnet_gateway_public_cert
  firewall_private_ip      = var.firewall_private_ip

  depends_on = [
    module.netsecgroup,
    azurerm_resource_group.rg_networking
  ]
}

module "firewall" {
  source       = "./Modules/Network/Firewall"
  location     = var.location
  name         = local.name
  tags         = var.tags
  rg_name      = azurerm_resource_group.rg_networking.name
  fw_subnet_id = module.networking.firewall_subnet_id_out
  depends_on = [
    module.networking,
    azurerm_resource_group.rg_networking
  ]
}

resource "azurerm_resource_group" "rg_private_dns_zones" {
  name     = local.dns-zone-resource-group
  location = var.location
}

module "private-dns-zones" {
  source    = "./Modules/Network/PrivateDNSZones"
  location  = var.location
  name      = local.name
  tags      = var.tags
  rg_name   = azurerm_resource_group.rg_private_dns_zones.name
  vnet_id   = module.networking.networking-output.datamz_vnet_id_out
  vnet_name = module.networking.networking-output.datamz_vnet_name_out
  dns_zones = var.privatelink-dns-zone-names
  depends_on = [
    azurerm_resource_group.rg_private_dns_zones,
    module.networking
  ]
}

resource "azurerm_resource_group" "rg_governance" {
  name     = local.governance-resource-group
  location = var.location
}

module "purview" {
  source                      = "./Modules/Governance/Purview"
  location                    = var.location
  name                        = local.name
  tags                        = var.tags
  rg_name                     = azurerm_resource_group.rg_governance.name
  svc_subnet_id               = module.networking.services_subnet_id_out
  purview_portal_dns_zone_id  = [module.private-dns-zones.priv-dns-zones["privatelink.purviewstudio.azure.com"].id]
  purview_account_dns_zone_id = [module.private-dns-zones.priv-dns-zones["privatelink.purview.azure.com"].id]
  keyvault_id                 = module.key-vault.keyvault-id
  depends_on = [
    azurerm_resource_group.rg_governance,
    module.private-dns-zones
  ]
}

module "key-vault" {
  source               = "./Modules/Governance/KeyVault"
  location             = var.location
  name                 = local.name
  tags                 = var.tags
  rg_name              = azurerm_resource_group.rg_governance.name
  dns_rg_id            = azurerm_resource_group.rg_private_dns_zones.id
  svc_subnet_id        = module.networking.services_subnet_id_out
  tenant_id            = coalesce(var.tenant_id, data.azurerm_client_config.current.tenant_id)
  keyvault_dns_zone_id = [module.private-dns-zones.priv-dns-zones["privatelink.vaultcore.azure.net"].id]
  depends_on = [
    azurerm_resource_group.rg_governance,
    module.private-dns-zones
  ]
}

resource "azurerm_resource_group" "rg_consumption" {
  name     = local.consumption-resource-group
  location = var.location
}

module "consumption" {
  source                  = "./Modules/Consumption/PrivateLinkHub"
  location                = var.location
  name                    = local.name
  tags                    = var.tags
  rg_name                 = azurerm_resource_group.rg_consumption.name
  svc_subnet_id           = module.networking.services_subnet_id_out
  synapse_web_dns_zone_id = [module.private-dns-zones.priv-dns-zones["privatelink.azuresynapse.net"].id]
  depends_on = [
    azurerm_resource_group.rg_consumption,
    module.private-dns-zones
  ]
}

resource "azurerm_resource_group" "rg_containers" {
  name     = local.containers-resource-group
  location = var.location
}

module "container-registry" {
  source          = "./Modules/Compute/Containers"
  location        = var.location
  name            = local.name
  tags            = var.tags
  rg_name         = azurerm_resource_group.rg_containers.name
  svc_subnet_id   = module.networking.services_subnet_id_out
  acr_dns_zone_id = [module.private-dns-zones.priv-dns-zones["privatelink.azurecr.io"].id]
  depends_on = [
    azurerm_resource_group.rg_containers,
    module.private-dns-zones
  ]
}

resource "azurerm_resource_group" "rg_monitoring" {
  name     = local.monitoring-resource-group
  location = var.location
}

module "log-analytics-ws" {
  source   = "./Modules/Governance/LogAnalytics"
  location = var.location
  name     = local.name
  tags     = var.tags
  rg_name  = local.monitoring-resource-group
  depends_on = [
    azurerm_resource_group.rg_monitoring
  ]
}


/*
module "policy-definitions" {
  source = "./Modules/Governance/Policy"
  #location                   = var.location
  #environment                = var.environment
  #rg_name                    = var.rg-monitoring-name
  #log-analytics-workspace-id = module.log-analytics-ws.log_analytics_ws_id-out
  template_file_vars = local.logAnalytics
  depends_on = [
    module.log-analytics-ws
  ]
}
*/

/*
module "policy-initaitives" {
  source             = "./Modules/Governance/Policy/PolicyInitiatives"
  location           = var.location
  environment        = var.environment
  rg_name            = var.rg-monitoring-name
  template_file_vars = local.log_analytics_workspace_id
  depends_on = [
    module.policy-definitions
  ]
}

module "policy-assignments" {
  source                     = "./Modules/Governance/Policy/PolicyAssignments"
  location                   = var.location
  environment                = var.environment
  rg_name                    = var.rg-monitoring-name
  log-analytics-workspace-id = module.log-analytics-ws.log_analytics_ws_id-out
  template_file_vars         = local.logAnalytics
  depends_on = [
    module.policy-definitions
  ]
}

*/
