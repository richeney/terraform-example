resource "azurerm_resource_group" "hub" {
  name     = "hub"
  location = var.location
  tags     = var.tags
}

module "hub_vnet" {
  source            = "../modules/vnet"
  module_depends_on = azurerm_resource_group.hub
  resource_group    = azurerm_resource_group.hub.name
  location          = azurerm_resource_group.hub.location
  tags              = azurerm_resource_group.hub.tags

  vnet_name     = "hub"
  address_space = ["10.1.0.0/24"]

  subnets = {
    "SharedServices"      = "10.1.0.0/25",
    "AzureFirewallSubnet" = "10.1.0.128/26",
    "AzureBastionSubnet"  = "10.1.0.192/27",
    "GatewaySubnet"       = "10.1.0.224/27"
  }

  service_endpoints = {
    "SharedServices" = ["Sql", "AzureActiveDirectory"]
  }
}

module "shared_services" {
  source            = "../modules/shared_services"
  module_depends_on = azurerm_resource_group.hub
  resource_group    = azurerm_resource_group.hub.name
  location          = azurerm_resource_group.hub.location
  tags              = azurerm_resource_group.hub.tags

  key_vault_name = "${var.hub}-key-vault"
  ssh_public_keys = [
    { username = "ubuntu", ssh_public_key_file = "~/.ssh/id_rsa.pub" },
    { username = "richeney", ssh_public_key_file = "~/.ssh/id_rsa.pub" }
  ]

  workspace_name              = "${var.hub}-workspace"
  recovery_vault_name         = "${var.hub}-recovery-vault"
  diagnostics_storage_account = "${var.hub}bootdiags"
}
