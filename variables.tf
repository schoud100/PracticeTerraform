
##################################
# Azure Resource Group variables #
##################################

variable "kube_resource_group_name" {
  type        = string
  description = "The name of an existing Resource Group"
}

variable "vaccine_location" {
  type        = string
  description = "Define the region the Azure Key Vault should be created, you should use the Resource Group location"
}

variable "stgaccount" {
  type        = string
  description = "The name of Storage Account"
}
