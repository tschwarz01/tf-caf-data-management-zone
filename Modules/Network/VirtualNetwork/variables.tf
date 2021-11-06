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

variable "name" {
  type        = string
  description = "Name which will be appended / prepended to Azure resource names"
}

variable "rg_name" {
  type        = string
  description = "The name of the resource group"
  default     = "rg-TerraformLabNetwork"
}

variable "nsg_id" {
  type        = string
  description = "Resource ID of the NSG"
}

variable "tags" {
  type        = map(string)
  description = "Tags that should be applied to all deployed resources"
}

variable "vnet_address_space" {
  type        = string
  description = "Address space to use for the Management Zone VNet"
}

variable "firewall_address_space" {
  type        = string
  description = "Address space to use for the Azure Firewall subnet within the Management Zone VNet"
}

variable "services_address_space" {
  type        = string
  description = "Address space to use for the Shared Services subnet within the Management Zone VNet"
}

variable "gateway_address_space" {
  type        = string
  description = "Address space to use for the Virtual Network Gateway subnet within the Management Zone VNet"
}

variable "vpn_client_address_space" {
  type        = string
  description = "Address space to use for VPN clients connecting through the Virtual Network Gateway"
}

variable "vnet_gateway_public_cert" {
  type        = string
  description = "Public root certificate to use to sign the client certificate used by the VPN clients to connect to the gateway"
}

variable "firewall_private_ip" {
  type        = string
  description = "The private IP address to be used by Azure Firewall.  This will be the first available IP from the subnet range defined by the firewall_subnet_address_space variable."
}
