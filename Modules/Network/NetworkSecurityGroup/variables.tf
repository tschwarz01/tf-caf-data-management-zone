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
  default     = "rg-networking"
}
