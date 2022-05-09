resource "azurerm_resource_group" "module_rg" {
  name     = "${var.base_name}RG"
  location = var.location
}