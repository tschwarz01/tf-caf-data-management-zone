variable "name" {
  type        = string
  description = "Name which will be appended / prepended to Azure resource names"
}

variable "tags" {
  type        = map(string)
  description = "Tags that should be applied to all deployed resources"
}


variable "location" {
  type        = string
  description = "The location of the resource group"
  default     = "southcentralus"
}

variable "rg_name" {
  type        = string
  description = "The name of the Data Management Zone monitoring resource group"
  default     = "rg-monitoring"
}

variable "log-analytics-workspace-id" {
  type    = string
  default = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f/resourceGroups/rg-monitoring/providers/Microsoft.OperationalInsights/workspaces/log-analytics-ws"
}
