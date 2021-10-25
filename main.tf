# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-data-management-zone-terraform"
    storage_account_name = "stgdatamgmtzoneterraform"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }

  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg_tf" {
  name = "rg-data-management-zone-terraform"
}

/*
data "azurerm_key_vault_secret" "kv_tf" {
  key_vault_id = var.key_vault_resource_id
}
*/



resource "azurerm_resource_group" "rg_networking" {
  name     = var.rg-network-name
  location = var.location
}
resource "azurerm_resource_group" "rg_private_dns_zones" {
  name     = var.rg-private-dns-zones-name
  location = var.location
}
resource "azurerm_resource_group" "rg_governance" {
  name     = var.rg-governance-name
  location = var.location
}

resource "azurerm_resource_group" "rg_automation" {
  name     = var.rg-automation-name
  location = var.location
}

resource "azurerm_resource_group" "rg_mgmt" {
  name     = var.rg-mgmt-name
  location = var.location
}

resource "azurerm_resource_group" "rg_containers" {
  name     = var.rg-containers-name
  location = var.location
}

resource "azurerm_resource_group" "rg_consumption" {
  name     = var.rg-consumption-name
  location = var.location
}


module "netsecgroup" {
  source      = "./Modules/Network/NetworkSecurityGroup"
  rg_name     = azurerm_resource_group.rg_networking.name
  location    = var.location
  environment = var.environment
}

module "networking" {
  source      = "./Modules/Network/VirtualNetwork"
  location    = var.location
  environment = var.environment
  rg_name     = azurerm_resource_group.rg_networking.name
  nsg_id      = module.netsecgroup.id_out
  depends_on = [
    module.netsecgroup,
    azurerm_resource_group.rg_networking
  ]
}
module "private-dns-zones" {
  source      = "./Modules/Network/PrivateDNSZones"
  location    = var.location
  environment = var.environment
  rg_name     = azurerm_resource_group.rg_private_dns_zones.name
  vnet_id     = module.networking.fxdatamz_vnet_id_out
  vnet_name   = module.networking.fxdatamz_vnet_name_out
  dns_zones   = var.privatelink-dns-zone-names
  depends_on = [
    azurerm_resource_group.rg_private_dns_zones,
    module.networking
  ]
}

module "purview" {
  source                      = "./Modules/Governance/Purview"
  location                    = var.location
  environment                 = var.environment
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
  environment          = var.environment
  rg_name              = azurerm_resource_group.rg_governance.name
  dns_rg_id            = azurerm_resource_group.rg_private_dns_zones.id
  svc_subnet_id        = module.networking.services_subnet_id_out
  tenant_id            = data.azurerm_client_config.current.tenant_id
  keyvault_dns_zone_id = [module.private-dns-zones.priv-dns-zones["privatelink.vaultcore.azure.net"].id]
  depends_on = [
    azurerm_resource_group.rg_governance,
    module.private-dns-zones
  ]
}

module "consumption" {
  source                  = "./Modules/Consumption/PrivateLinkHub"
  location                = var.location
  environment             = var.environment
  rg_name                 = azurerm_resource_group.rg_consumption.name
  svc_subnet_id           = module.networking.services_subnet_id_out
  synapse_web_dns_zone_id = [module.private-dns-zones.priv-dns-zones["privatelink.azuresynapse.net"].id]
  depends_on = [
    azurerm_resource_group.rg_consumption,
    module.private-dns-zones
  ]
}

module "container-registry" {
  source          = "./Modules/Compute/Containers"
  location        = var.location
  environment     = var.environment
  rg_name         = azurerm_resource_group.rg_containers.name
  svc_subnet_id   = module.networking.services_subnet_id_out
  acr_dns_zone_id = [module.private-dns-zones.priv-dns-zones["privatelink.azurecr.io"].id]
  depends_on = [
    azurerm_resource_group.rg_containers,
    module.private-dns-zones
  ]
}

module "log-analytics-ws" {
  source      = "./Modules/Governance/LogAnalytics"
  location    = var.location
  environment = var.environment
  rg_name     = var.rg-monitoring-name
}

module "firewall" {
  source       = "./Modules/Network/Firewall"
  location     = var.location
  environment  = var.environment
  rg_name      = azurerm_resource_group.rg_networking.name
  fw_subnet_id = module.networking.firewall_subnet_id_out
  depends_on = [
    module.networking,
    azurerm_resource_group.rg_networking
  ]
}

/*
locals {
  log_analytics_workspace_id = <<PARAMETERS
{
  "logAnalytics": {
    "value": "${module.log-analytics-ws.log_analytics_id}"
  }
}
PARAMETERS
}

locals {
  logAnalytics = { value = "${module.log-analytics-ws.log_analytics_id}" }
}

*/
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
