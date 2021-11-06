
variable "template_file_vars" {
  type        = map(any)
  description = "If specified, provides the ability to define custom template vars used when reading in template files from the library_path"
  default = {
    "root_scope_resource_id" = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f"
  }
}

variable "scope_id" {
  type        = string
  description = "Specifies the scope to apply the archetype resources against."
  default     = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f"

  validation {
    condition     = can(regex("^/(subscriptions|providers/Microsoft.Management/managementGroups)/[a-z0-9-]{2,36}$", var.scope_id))
    error_message = "The scope_id value must be a valid Subscription or Management Group ID."
  }
}

variable "log-analytics-workspace-id" {
  type    = string
  default = "/subscriptions/47f7e6d7-0e52-4394-92cb-5f106bbc647f/resourceGroups/rg-monitoring/providers/Microsoft.OperationalInsights/workspaces/log-analytics-ws"
}


variable "name" {
  type        = string
  description = "Name which will be appended / prepended to Azure resource names"
}

variable "tags" {
  type        = map(string)
  description = "Tags that should be applied to all deployed resources"
}
