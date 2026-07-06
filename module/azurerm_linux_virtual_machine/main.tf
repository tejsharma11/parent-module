data "azurerm_key_vault" "kv" {
  name                = "kv-dev-tej"
  resource_group_name = "rg-dev"
}

data "azurerm_key_vault_secret" "username" {
  name         = "vm-admin-username"
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_key_vault_secret" "password" {
  name         = "vm-admin-password"
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_virtual_machine" "vmachine" {
  for_each              = var.vmdemo
  name                  = each.value.name
  resource_group_name   = each.value.resource_group_name
  location              = each.value.location
  vm_size                  = "Standard_d2s_v3"
  network_interface_ids = each.value.network_interface_ids

  storage_os_disk {
    name = "${each.value.name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
    os_profile {
  computer_name = "${each.value.name}-vm"
  admin_username = data.azurerm_key_vault_secret.username.value
  admin_password = data.azurerm_key_vault_secret.password.value
  #   admin_username = each.value.admin_username
  # admin_password = each.value.admin_password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
 storage_image_reference {
    publisher = each.value.publisher
    offer     = each.value.offer
    sku       = each.value.sku
    version   = each.value.version
  }
}