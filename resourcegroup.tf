resource "azurerm_resource_group" "Terra_aks_rg" {
  name     = var.resource_group
  location = var.azure_region
}
