variable "location" {
  type        = string
  description = "The location of the resource group"
  default     = "southcentralus"
}
variable "environment" {
  type        = string
  description = "The release stage of the environment"
  default     = "TerraformLab"
}
variable "rg_name" {
  type        = string
  description = "The name of the resource group"
  default     = "rg-TerraformLabNetwork"
}

variable "svc_subnet_id" {
  type        = string
  description = "Data Management Zone Services Subnet ID"
}

variable "synapse_web_dns_zone_id" {
  type        = list(string)
  description = "Private DNS Zone ID for the Azure Synapse Analytics Private Link Hub resource type"
}
