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

#Create Azure Storage Container
resource "azurerm_storage_container" "blobcontainer" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.storaccount.name
  container_access_type = "private"
  
}

#Create Virtual Network aka VNET
resource "azurerm_virtual_network" "web-server-vnet" {
  name                           = var.vnet_name
  address_space                  = var.vnet_address_space
  location                       = azurerm_resource_group.web_server_rg.location
  resource_group_name            = azurerm_resource_group.web_server_rg.name 
  tags = var.tags
}

#Create subnets using for_each
resource "azurerm_subnet" "subnet" {
  for_each = var.subnets
  resource_group_name          = var.kube_resource_group_name
  virtual_network_name         = azurerm_virtual_network.web-server-vnet.name
  name                         = each.value["name"]
  address_prefixes               = each.value["address_prefixes"]
}

#Create public Ip Address for Bastion Host
resource "azurerm_public_ip" "bastion_pubip" {
  name                         = "${var.bastionhost_name}PubIP"
  location                     = azurerm_resource_group.web_server_rg.location
  resource_group_name          = azurerm_resource_group.web_server_rg.name
  allocation_method            = "Static"
  sku                          = "Standard"
  tags                         = var.tags
}


#Create Bastion Host
resource "azurerm_bastion_host" "bastion" {
  name                         = var.bastionhost_name
  location                     = azurerm_resource_group.web_server_rg.location
  resource_group_name          = azurerm_resource_group.web_server_rg.name
  tags                         = var.tags

  ip_configuration {
    name = "bastion_config"
    subnet_id = azurerm_subnet.subnet["bastion_subnet"].id
    public_ip_address_id = azurerm_public_ip.bastion_pubip.id
  }
}  