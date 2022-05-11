terraform {
  backend "azurerm" {
    resource_group_name = "TfstateRG01"
    storage_account_name = "tfstatestoraccount"
    container_name = "tfstate"
    key = "terraform.tfstate"   // name of any file to be created under container
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.63.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "5cecbbaa-a38e-4827-8324-30600cfe4b44"
  tenant_id       = "b41b72d0-4e9f-4c26-8a69-f949f367c91d"  
  client_id       = var.clientid
  client_secret   = var.spnkvsecret
  features {}
}



data "azurerm_client_config" "current" {}

locals {
  resource_group="TestPractice"
  location="CentralIndia"
  tags = {
        environment ="Lab"
        owner = "Shlagha"
    }
}


#Create Network Security Group
resource "azurerm_network_security_group" "sec-g" {
  name                = "NetSecCluster"
  location            = local.location
  resource_group_name = local.resource_group
}

#Create Azure VNet
resource "azurerm_virtual_network" "vnet" {
  name                = "Vnet-aks1"
  location            = local.location
  resource_group_name = local.resource_group
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.sec-g.id
  }

  tags = local.tags
}


#Create Azure Kubernetes Cluster
resource "azurerm_kubernetes_cluster" "k8s" {
    name                       = "ClusterDemo-aks"
    location                   = local.location
    resource_group_name        = local.resource_group
    dns_prefix                 = "poc"
    
  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = data.azurerm_key_vault_secret.ssh_public_key.value
    }
  }

  service_principal {
    client_id     = var.clientid
    client_secret = var.spnkvsecret
  }
  
    default_node_pool {
          name            = "default"
          node_count      = 3
          vm_size         = "Standard_D2_v2"
          os_disk_size_gb = 30
        }

    
    tags = local.tags
}


resource "azurerm_kubernetes_cluster_node_pool" "pool1" {
  name                  = "userpool1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  enable_auto_scaling   = true
  os_disk_size_gb       = 30
  max_count             = 3
  min_count             = 1
  tags                  = local.tags
}

data "azurerm_key_vault" "app_vault" {  
  name                        = "aks-keyvault-cluster"
  resource_group_name         = local.resource_group
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "aks-secret"
  key_vault_id = data.azurerm_key_vault.app_vault.id
}





