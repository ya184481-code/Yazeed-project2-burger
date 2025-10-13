
resource "azurerm_resource_group" "main-rg" {
  name     = "RG-Yazeed-project2"
  location = "central india"
  tags = {
    "provisioner" = "${lower(replace(var.author, " ", "-"))}-terraform"
  }
}
