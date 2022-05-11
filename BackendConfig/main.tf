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
}


resource "azurerm_resource_group" "web_server_rg" {
  name     = var.kube_resource_group_name
  location = var.vaccine_location
  tags = var.tags
}

#Create Azure Storage Account
resource "azurerm_storage_account" "storaccount" {
  name                     = var.stgaccount
  resource_group_name      = azurerm_resource_group.web_server_rg.name
  location                 = azurerm_resource_group.web_server_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = var.tags
}

#Create Azure Blob Container
resource "azurerm_storage_container" "blobcontainer" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.storaccount.name
  container_access_type = "private"
  
}

//Powershell Command to get storage access key and store in environment variable
//$ACCOUNT_KEY = $(az storage account keys list --resource-group backendgroup --acount-name storaccount --query $env:ARM_ACCESS_KEY=$ACCOUNT_KEY)