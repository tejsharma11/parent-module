
resource "azurerm_subnet" "subnetvirtual" {
  for_each             = var.subnet
  name                 = each.key
  resource_group_name  = each.value.rg
  virtual_network_name = each.value.virtualnet
  address_prefixes     = each.value.aspace
}