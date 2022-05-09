
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

variable "vnet_name" {
  type = string
  description = "The name of the vnet"
  default = "VNetTest"
}

variable "vnet_address_space" {
  type = list(any)
  description = "The address space of the VNet"
  default = [ "10.13.0.0/16" ]
}

variable "subnets" {
    type = map(any)
    default = {
        subnet_1 = {
            name = "subnet_1"
            address_prefixes = ["10.13.1.0/24"]
        }  

        subnet_2 = {
            name = "subnet_2"
            address_prefixes = ["10.13.2.0/24"]
        }

        subnet_3 = {
            name = "subnet_3"
            address_prefixes = ["10.13.3.0/24"]
        }

        #The name must be AzureBastionSubnet
        #Azure Bastion is a service you deploy that lets you connect to a virtual machine using your browser and the Azure portal.
        bastion_subnet = {
            name = "AzureBastionSubnet"
            address_prefixes = ["10.13.250.0/24"]
        }
    }
}

variable "bastionhost_name" {
  type = string
  description = "The name of the bastion host"
  default = "BastionHost"
}

