
variable "environment" {
  type        = string
  description = "The release stage of the environment"
  default     = "dmz"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
  default     = "southcentralus"
}

###################################################
# Environment Specs - Resource Groups
###################################################


variable "rg-dmz-net-name" {
  type        = string
  description = "The name of the Data Management Zone network resource group"
  default     = "rg-dmz-network"
}

variable "rg-dmz-automation-name" {
  type        = string
  description = "The name of the Data Management Zone automation resource group"
  default     = "rg-dmz-automation"
}

variable "rg-dmz-global-dns-name" {
  type        = string
  description = "The name of the Data Management Zone global-dns resource group"
  default     = "rg-dmz-global-dns"
}

variable "rg-dmz-governance-name" {
  type        = string
  description = "The name of the Data Management Zone governance resource group"
  default     = "rg-dmz-governance"
}

variable "rg-dmz-mgmt-name" {
  type        = string
  description = "The name of the Data Management Zone mgmt resource group"
  default     = "rg-dmz-mgmt"
}

variable "rg-dmz-container-name" {
  type        = string
  description = "The name of the Data Management Zone container resource group"
  default     = "rg-dmz-container"
}

variable "rg-dmz-consumption-name" {
  type        = string
  description = "The name of the Data Management Zone consumption resource group"
  default     = "rg-dmz-consumption"
}

variable "rg-dmz-monitor-name" {
  type        = string
  description = "The name of the Data Management Zone monitoring resource group"
  default     = "rg-dmz-monitor"
}

/*
variable "privatelink-dns-zone-names" {
  type        = list(string)
  description = "List of Azure Private Link DNS Zone names"
  default = [
    "privatelink.azure-automation.net",
    "privatelink.database.windows.net",
    "privatelink.sql.azuresynapse.net",
    "privatelink.sql.azuresynapse.net",
    "privatelink.dev.azuresynapse.net",
    "privatelink.azuresynapse.net",
    "privatelink.blob.core.windows.net",
    "privatelink.table.core.windows.net",
    "privatelink.queue.core.windows.net",
    "privatelink.file.core.windows.net",
    "privatelink.web.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.documents.azure.com",
    "privatelink.mongo.cosmos.azure.com",
    "privatelink.cassandra.cosmos.azure.com",
    "privatelink.gremlin.cosmos.azure.com",
    "privatelink.table.cosmos.azure.com",
    "privatelink.postgres.database.azure.com",
    "privatelink.mysql.database.azure.com",
    "privatelink.mariadb.database.azure.com",
    "privatelink.vaultcore.azure.net",
    "privatelink.search.windows.net",
    "privatelink.azurecr.io",
    "privatelink.azconfig.io",
    "privatelink.siterecovery.windowsazure.com",
    "privatelink.servicebus.windows.net",
    "privatelink.servicebus.windows.net",
    "privatelink.azure-devices.net",
    "privatelink.servicebus.windows.net1",
    "privatelink.servicebus.windows.net",
    "privatelink.eventgrid.azure.net",
    "privatelink.eventgrid.azure.net",
    "privatelink.azurewebsites.net",
    "privatelink.api.azureml.ms",
    "privatelink.notebooks.azure.net",
    "privatelink.service.signalr.net",
    "privatelink.monitor.azure.com",
    "privatelink.oms.opinsights.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.blob.core.windows.net",
    "privatelink.cognitiveservices.azure.com",
    "privatelink.afs.azure.net",
    "privatelink.datafactory.azure.net",
    "privatelink.adf.azure.com",
    "privatelink.redis.cache.windows.net",
    "privatelink.redisenterprise.cache.azure.net",
    "privatelink.purview.azure.com",
    "privatelink.purviewstudio.azure.com",
    "privatelink.digitaltwins.azure.net",
    "privatelink.azurehdinsight.net"
  ]
}
*/

variable "privatelink-dns-zone-names" {
  type        = list(string)
  description = "List of Azure Private Link DNS Zone names"
  default = [
    "privatelink.sql.azuresynapse.net",
    "privatelink.dev.azuresynapse.net",
    "privatelink.queue.core.windows.net",
    "privatelink.dfs.core.windows.net",
    "privatelink.blob.core.windows.net",
    "privatelink.servicebus.windows.net",
    "privatelink.vaultcore.azure.net",
    "privatelink.purviewstudio.azure.com",
    "privatelink.purview.azure.com",
    "privatelink.azuresynapse.net",
    "privatelink.azurecr.io"
  ]
}

variable "key_vault_resource_id" {
  type        = string
  description = "the resource id of the main key vault"
  default     = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f/resourceGroups/rg-data-management-zone-terraform/providers/Microsoft.KeyVault/vaults/keyvault-tf"
}
