
locals {
  hub_vm_defaults = {
    module_depends_on    = ["module.hub_vnet"]
    resource_group_name  = azurerm_resource_group.hub.name
    location             = azurerm_resource_group.hub.location
    tags                 = azurerm_resource_group.hub.tags
    key_vault_id         = module.shared_services.key_vault.id
    boot_diagnostics_uri = module.shared_services.diags.uri

    admin_username       = "ubuntu"
    ssh_users            = []
    subnet_id            = module.hub_vnet.subnets["SharedServices"].id
    vm_size              = "Standard_B1ls"
    storage_account_type = "Standard_LRS"
  }
}

module "management_vm" {
  source          = "../modules/linux_vm"
  defaults        = local.hub_vm_defaults
  name            = "testLinuxVm"
  source_image_id = data.azurerm_image.ubuntu.id
}

module "custom_pair" {
  source          = "../modules/linux_vm"
  defaults        = local.hub_vm_defaults
  names           = ["sig-a", "sig-b"]
  source_image_id = data.azurerm_shared_image.ubuntuBase.id
}
