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

module "ResourceGroup" {
  source = "D:\\Practice_EPAM\\MODULE EXAMPLE\\ResourceGroup"
  base_name = "TerraformExModules"
  location = "Central India"
}

module "StgAccount" {
  source = "D:\\Practice_EPAM\\MODULE EXAMPLE\\StgAccount"
  base_name = "TerraformStg"
  resource_group_name = module.ResourceGroup.RG_Name_Out
  location = "Central India"
}