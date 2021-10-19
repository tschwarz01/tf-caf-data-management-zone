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

resource "azurerm_resource_group" "rg_dmz_net" {
  name     = var.rg-dmz-net-name
  location = var.location
}
resource "azurerm_resource_group" "rg_dmz_global_dns" {
  name     = var.rg-dmz-global-dns-name
  location = var.location
}
resource "azurerm_resource_group" "rg_dmz_governance" {
  name     = var.rg-dmz-governance-name
  location = var.location
}

resource "azurerm_resource_group" "rg_dmz_automation" {
  name     = var.rg-dmz-automation-name
  location = var.location
}

resource "azurerm_resource_group" "rg_dmz_mgmt" {
  name     = var.rg-dmz-mgmt-name
  location = var.location
}

resource "azurerm_resource_group" "rg_dmz_container" {
  name     = var.rg-dmz-container-name
  location = var.location
}

resource "azurerm_resource_group" "rg_dmz_consumption" {
  name     = var.rg-dmz-consumption-name
  location = var.location
}


module "dmz-nsg" {
  source      = "./Modules/Network/NetworkSecurityGroup"
  rg_name     = azurerm_resource_group.rg_dmz_net.name
  location    = var.location
  environment = var.environment
}

module "dmz-vnet" {
  source      = "./Modules/Network/VirtualNetwork"
  location    = var.location
  environment = var.environment
  rg_name     = azurerm_resource_group.rg_dmz_net.name
  nsg_id      = module.dmz-nsg.id_out
  depends_on = [
    module.dmz-nsg,
    azurerm_resource_group.rg_dmz_net
  ]
}
module "dmz-private-dns-zones" {
  source      = "./Modules/Network/PrivateDNSZones"
  location    = var.location
  environment = var.environment
  rg_name     = azurerm_resource_group.rg_dmz_global_dns.name
  vnet_id     = module.dmz-vnet.dmz_vnet_id_out
  vnet_name   = module.dmz-vnet.dmz_vnet_name_out
  dns_zones   = var.privatelink-dns-zone-names
  depends_on = [
    azurerm_resource_group.rg_dmz_global_dns,
    module.dmz-vnet
  ]
}

module "dmz-purview" {
  source                      = "./Modules/Governance/Purview"
  location                    = var.location
  environment                 = var.environment
  rg_name                     = azurerm_resource_group.rg_dmz_governance.name
  svc_subnet_id               = module.dmz-vnet.services_subnet_id_out
  purview_portal_dns_zone_id  = [module.dmz-private-dns-zones.priv-dns-zones["privatelink.purviewstudio.azure.com"].id]
  purview_account_dns_zone_id = [module.dmz-private-dns-zones.priv-dns-zones["privatelink.purview.azure.com"].id]
  keyvault_id                 = module.dmz-key-vault.keyvault-id
  depends_on = [
    azurerm_resource_group.rg_dmz_governance,
    module.dmz-private-dns-zones
  ]
}

module "dmz-key-vault" {
  source               = "./Modules/Governance/KeyVault"
  location             = var.location
  environment          = var.environment
  rg_name              = azurerm_resource_group.rg_dmz_governance.name
  dns_rg_id            = azurerm_resource_group.rg_dmz_global_dns.id
  svc_subnet_id        = module.dmz-vnet.services_subnet_id_out
  tenant_id            = data.azurerm_client_config.current.tenant_id
  keyvault_dns_zone_id = [module.dmz-private-dns-zones.priv-dns-zones["privatelink.vaultcore.azure.net"].id]
  depends_on = [
    azurerm_resource_group.rg_dmz_governance,
    module.dmz-private-dns-zones
  ]
}

module "dmz-consumption-synpase-hub" {
  source                  = "./Consumption/PrivateLinkHub"
  location                = var.location
  environment             = var.environment
  rg_name                 = azurerm_resource_group.rg_dmz_consumption.name
  svc_subnet_id           = module.dmz-vnet.services_subnet_id_out
  synapse_web_dns_zone_id = [module.dmz-private-dns-zones.priv-dns-zones["privatelink.azuresynapse.net"].id]
  depends_on = [
    azurerm_resource_group.rg_dmz_consumption,
    module.dmz-private-dns-zones
  ]
}

module "dmz-acr" {
  source          = "./Modules/Compute/Containers"
  location        = var.location
  environment     = var.environment
  rg_name         = azurerm_resource_group.rg_dmz_container.name
  svc_subnet_id   = module.dmz-vnet.services_subnet_id_out
  acr_dns_zone_id = [module.dmz-private-dns-zones.priv-dns-zones["privatelink.azurecr.io"].id]
  depends_on = [
    azurerm_resource_group.rg_dmz_container,
    module.dmz-private-dns-zones
  ]
}


/*
# Commenting out temporarily to reduce deploy / destroy time


module "dmz-firewall" {
  source       = "./Modules/Network/Firewall"
  location     = var.location
  environment  = var.environment
  rg_name      = azurerm_resource_group.rg_dmz_net.name
  fw_subnet_id = module.dmz-vnet.firewall_subnet_id_out
  depends_on = [
    module.dmz-vnet,
    azurerm_resource_group.rg_dmz_net
  ]
}
*/


