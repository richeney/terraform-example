data "azurerm_client_config" "current" {
}

locals {
  ssh_public_keys = {
    // Convert list of objects to simpler map
    // Maps like this cannot be defined in structural types
    for object in var.hub.ssh_public_keys :
    object.username => file(object.ssh_public_key_file)
  }
}
resource "azurerm_resource_group" "hub" {
  name     = var.hub.resource_group
  location = var.hub.location
  tags     = var.hub.tags
}

resource "random_string" "kv" {
  length  = 8
  special = false
  upper   = false
  lower   = true
  number  = true
}

resource "azurerm_key_vault" "hub" {
  name                = "${substr(var.hub.key_vault_name, 0, 15)}-${random_string.kv.result}"
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  tags                = azurerm_resource_group.hub.tags
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name                        = "standard"
  enabled_for_deployment          = false
  enabled_for_template_deployment = false
  enabled_for_disk_encryption     = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "List",
      "Update",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "List",
      "Delete",
    ]
  }
}

resource "random_pet" "example" {}

resource "azurerm_key_vault_secret" "example" {
  key_vault_id = azurerm_key_vault.hub.id
  name         = "example-secret"
  content_type = "example"
  value        = random_pet.example.id
}

resource "azurerm_key_vault_secret" "ssh_pub_key" {
  // Loop through the list and create a secret for each user and their public key
  // for_)each only works on simple maps or sets, so generate one
  key_vault_id = azurerm_key_vault.hub.id
  for_each     = local.ssh_public_keys

  name         = each.key
  value        = each.value
  content_type = "ssh-pub-key"
}

resource "null_resource" "ssh_pub_key_sleep" {
  # Any changes to these key vault secrets will trigger a sleep
  triggers = local.ssh_public_keys

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "azurerm_storage_account" "diags" {
  name                = "${substr(lower(var.hub.diagnostics_storage_account), 0, 15)}${random_string.kv.result}"
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  tags                = azurerm_resource_group.hub.tags

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"


}

/*
Needs storage blob contributor permissions
resource "azurerm_storage_container" "diags" {
  name                  = "boot-diagnostics"
  storage_account_name  = azurerm_storage_account.diags.name
  container_access_type = "private"
}
*/