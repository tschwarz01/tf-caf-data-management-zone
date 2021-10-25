variable "location" {
  type        = string
  description = "The location of the resource group"
  default     = "southcentralus"
}
variable "environment" {
  type        = string
  description = "The release stage of the environment"
  default     = "fxdatamz"
}
variable "rg_name" {
  type        = string
  description = "The name of the resource group"
}

variable "fw_subnet_id" {
  type        = string
  description = "Firewall subnet id from the vnet module"
}
