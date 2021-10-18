variable "location" {
  type        = string
  description = "The location of the resource group"
  default     = "southcentralus"
}
variable "environment" {
  type        = string
  description = "The release stage of the environment"
  default     = "dmz"
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group"
  default     = "rg-dmz-governance"
}

variable "dns_rg_id" {
  type        = string
  description = "Private DNS Zones Resource Group ID"
}

variable "svc_subnet_id" {
  type        = string
  description = "Data Management Zone Services Subnet ID"
}
