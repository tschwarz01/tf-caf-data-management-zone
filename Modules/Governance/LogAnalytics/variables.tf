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

variable "rg_name" {
  type        = string
  description = "The name of the Data Management Zone monitoring resource group"
  default     = "rg-dmz-monitor"
}

variable "log-analytics-workspace-id" {
  type    = string
  default = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f/resourceGroups/rg-dmz-monitor/providers/Microsoft.OperationalInsights/workspaces/dmz-log-analytics-ws"
}
