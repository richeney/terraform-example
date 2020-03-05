module "hub" {
  source = "./modules/hub"

  hub = {
    location       = var.location
    resource_group = var.hub_resource_group
    tags           = var.tags
    vnet = {
      name          = "hub"
      address_space = ["10.0.0.0/16"]
      dns           = []
    }
    subnets = [
      {
        name           = "subnet1"
        address_prefix = "10.0.1.0/24"
        nsg_id         = ""
      }
    ]
    key_vault_name = "${var.prefix}-key-vault"
    ssh_public_keys = [
      { username = "ubuntu", ssh_public_key_file = "~/.ssh/id_rsa.pub" },
      { username = "richeney", ssh_public_key_file = "~/.ssh/id_rsa.pub" }
    ]
    workspace_name              = "${var.prefix}-workspace"
    recovery_vault_name         = "${var.prefix}-recovery-vault"
    diagnostics_storage_account = "${var.prefix}bootdiags"
  }
}

/*
resource "azurerm_resource_group" "test" {
  name     = "deleteme"
  location = var.location
}

module "deleteme" {
  source         = "./modules/linux_vm"
  resource_group = azurerm_resource_group.test.name
  subnet_id      = azurerm_subnet.test.id

  name = "deleteme"

  key_vault_id   = module.hub.key_vault_id
  admin_username = "ubuntu"
  ssh_users      = module.hub.ssh_users
}
*/