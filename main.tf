terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.63.0"
    }
  }
}

provider "azurerm" {
 features {}
  subscription_id = var.subscription_id
  client_id       = "5a29a8fe-7f2d-4980-a134-1f86ade66702"
  client_secret   = var.client_secret
  tenant_id       = "b41b72d0-4e9f-4c26-8a69-f949f367c91d"
}


resource "azurerm_resource_group" "web_server_rg" {
  name     = var.kube_resource_group_name
  location = var.vaccine_location
}
