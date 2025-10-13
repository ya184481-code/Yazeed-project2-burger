resource "azurerm_virtual_network" "vnet" {
  name                = "yazeed-vnet-${lower(replace(var.author, " ", "-"))}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = ["10.0.0.0/16"]
}
