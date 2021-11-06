variable "environment" {
  type        = string
  description = "The release stage of the environment"
}

variable "prefix" {
  type        = string
  description = "prefix to be used for resource names"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "tags" {
  type        = map(string)
  description = "Tags that should be applied to all deployed resources"
}

variable "tenant_id" {
  type = string
}

variable "privatelink-dns-zone-names" {
  type        = list(string)
  description = "List of Azure Private Link DNS Zone names"
}

variable "vnet_address_space" {
  type        = string
  description = "Address space to use for the Management Zone VNet"
}

variable "firewall_subnet_address_space" {
  type        = string
  description = "Address space to use for the Azure Firewall subnet within the Management Zone VNet"
}

variable "services_subnet_address_space" {
  type        = string
  description = "Address space to use for the Shared Services subnet within the Management Zone VNet"
}

variable "gateway_subnet_address_space" {
  type        = string
  description = "Address space to use for the Virtual Network Gateway subnet within the Management Zone VNet"
}

variable "vpn_client_address_space" {
  type        = string
  description = "Address space to use for VPN clients connecting through the Virtual Network Gateway"
}

variable "firewall_private_ip" {
  type        = string
  description = "The private IP address to be used by Azure Firewall.  This will be the first available IP from the subnet range defined by the firewall_subnet_address_space variable."
}
variable "vnet_gateway_public_cert" {
  type        = string
  description = "Public root certificate to use to sign the client certificate used by the VPN clients to connect to the gateway"
}
