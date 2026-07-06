resource "azurerm_bastion_host" "jump" {
  for_each            = var.bastion
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastionsubnet["bastionsubnet1"].id
    public_ip_address_id = each.value.public_ip_address_id
  }
}