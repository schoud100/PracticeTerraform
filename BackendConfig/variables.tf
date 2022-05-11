##################################
# Azure Resource Group variables #
##################################

variable "kube_resource_group_name" {
  type        = string
  description = "The name of an existing Resource Group"
  default = "TestPractice"
}

variable "vaccine_location" {
  type        = string
  description = "Define the region the Azure Key Vault should be created, you should use the Resource Group location"
  default = "Central India"
}

variable "stgaccount" {
  type        = string
  description = "The name of Storage Account"
  default = "tfstatestoraccount"
}

variable "tags" {
  type = map(string)
  description = "Tags used for deployment"
  default = {
    "Environment" = "Lab"
    "Owner" = "Shlagha"
  }
}