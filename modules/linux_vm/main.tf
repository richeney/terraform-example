locals {
  names = length(var.names) > 0 ? var.names : list(var.name)
}

data "azurerm_resource_group" "vm" {
  name = var.resource_group
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  for_each     = var.ssh_users
  name         = each.value
  key_vault_id = var.key_vault_id
}

resource "azurerm_network_interface" "vm" {
  for_each            = toset(local.names)
  name                = "${each.value}-nic"
  location            = data.azurerm_resource_group.vm.location
  resource_group_name = data.azurerm_resource_group.vm.name
  tags                = data.azurerm_resource_group.vm.tags

  ip_configuration {
    name                          = "ipconfiguration1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  for_each            = toset(local.names)
  location            = data.azurerm_resource_group.vm.location
  resource_group_name = data.azurerm_resource_group.vm.name
  tags                = data.azurerm_resource_group.vm.tags

  name                            = each.value // also used for computer_name, i.e. hostname
  admin_username                  = var.admin_username
  disable_password_authentication = true
  size                            = var.vm_size
  // zone                            = 'A'

  network_interface_ids = [azurerm_network_interface.vm[each.key].id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "${each.value}-os"
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = data.azurerm_key_vault_secret.ssh_public_key[var.admin_username].value
  }


  // custom_data = "Base64 encoded custom data"


  // dynamic "admin_ssh_key" {
  //   for_each = var.ssh_users
  //   content {
  //     username   = admin_ssh_key.value
  //     public_key = data.azurerm_key_vault_secret.ssh_public_key[admin_ssh_key.value].value
  //   }
  // }

  identity {
    type = "SystemAssigned"
  }

  // secret {
  //   key_vault_id = var.key_vault_id
  //   certificate  {
  //       url = data.azurerm_key_vault_certificate.cert.secret_id
  //   }
  // }

  // boot_diagnostics {
  //   storage_account_uri = var.diagnostics_workspace
  // }
}