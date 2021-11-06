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
  default     = "rg-governance"
}

variable "dns_rg_id" {
  type        = string
  description = "Private DNS Zones Resource Group ID"
}

variable "svc_subnet_id" {
  type        = string
  description = "Data Management Zone Services Subnet ID"
}

variable "tenant_id" {
  type        = string
  description = "Azure tenant id"
}

variable "keyvault_dns_zone_id" {
  type        = list(string)
  description = "Private DNS Zone ID for the Azure Key Vault resource type"
}
