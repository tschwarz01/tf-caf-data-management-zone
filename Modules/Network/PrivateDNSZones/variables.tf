variable "location" {
  type        = string
  description = "The location of the resource group"
  default     = "southcentralus"
}

variable "name" {
  type        = string
  description = "Name which will be appended / prepended to Azure resource names"
}

variable "tags" {
  type        = map(string)
  description = "Tags that should be applied to all deployed resources"
}


variable "rg_name" {
  type        = string
  description = "The name of the resource group"
  default     = "rg-datamz-global-dns"
}

variable "vnet_id" {
  type        = string
  description = "The resource id of the virtual network to which private dns zones should be linked"
}

variable "vnet_name" {
  type        = string
  description = "The resource name of the virtual network to which private dns zones should be linked"
}

variable "dns_zones" {
  type        = set(string)
  description = "List of Private DNS Zones utilized by Azure Private Link resources"
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
