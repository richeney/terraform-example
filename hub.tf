resource "azurerm_resource_group" "hub" {
  name     = "hub"
  location = var.location
  tags     = var.tags
}

module "hub" {
  source  = "./modules/hub"
  depends = [azurerm_resource_group.hub]

  resource_group     = azurerm_resource_group.hub.name
  vnet_name          = var.hub
  vnet_address_space = var.hub_vnet_address_space

  subnets = [
    {
      name           = "GatewaySubnet"
      address_prefix = cidrsubnet(var.hub_vnet_address_space[0], 8, 0)
      nsg_id         = null
    },
    {
      name           = "SharedServices"
      address_prefix = cidrsubnet(var.hub_vnet_address_space[0], 8, 1)
      nsg_id         = null
    }
  ]

  service_endpoints = {
    "SharedServices" = ["Sql", "AzureActiveDirectory"]
  }

  key_vault_name = "${var.hub}-key-vault"
  ssh_public_keys = [
    { username = "ubuntu", ssh_public_key_file = "~/.ssh/id_rsa.pub" },
    { username = "richeney", ssh_public_key_file = "~/.ssh/id_rsa.pub" }
  ]

  workspace_name              = "${var.hub}-workspace"
  recovery_vault_name         = "${var.hub}-recovery-vault"
  diagnostics_storage_account = "${var.hub}bootdiags"
}
