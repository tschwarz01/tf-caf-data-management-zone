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
}

variable "fw_subnet_id" {
  type        = string
  description = "Firewall subnet id from the vnet module"
}
