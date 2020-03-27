data "azurerm_client_config" "current" {
}

data "azurerm_resource_group" "hub" {
  name       = var.resource_group
  depends_on = [var.module_depends_on]
}

locals {
  location = var.location != "" ? var.location : data.azurerm_resource_group.hub.location
  tags     = merge(data.azurerm_resource_group.hub.tags, var.tags)

  ssh_public_keys = {
    for object in var.ssh_public_keys :
    object.username => file(object.ssh_public_key_file)
  }
}

resource "random_string" "hub" {
  length  = 10
  special = false
  upper   = false
  lower   = true
  number  = true
}

resource "azurerm_key_vault" "hub" {
  name                = "${substr(var.key_vault_name, 0, 13)}-${random_string.hub.result}"
  resource_group_name = data.azurerm_resource_group.hub.name
  location            = local.location
  tags                = local.tags
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

resource "azurerm_log_analytics_workspace" "hub" {
  name                = "${var.workspace_name}-${random_string.hub.result}"
  resource_group_name = data.azurerm_resource_group.hub.name
  location            = local.location
  tags                = local.tags

  sku               = "PerGB2018"
  retention_in_days = var.workspace_retention
}

resource "azurerm_key_vault_secret" "hub_workspace_name" {
  key_vault_id = azurerm_key_vault.hub.id
  name         = "hub-workspace-name"
  value        = azurerm_log_analytics_workspace.hub.name
  content_type = "workspace-name"
}
resource "azurerm_key_vault_secret" "hub_workspace_key" {
  key_vault_id = azurerm_key_vault.hub.id
  name         = "hub-workspace-key"
  value        = azurerm_log_analytics_workspace.hub.secondary_shared_key
  content_type = "workspace-key"
}

resource "azurerm_storage_account" "diags" {
  name                = "${substr(lower(var.diagnostics_storage_account), 0, 14)}${random_string.hub.result}"
  resource_group_name = data.azurerm_resource_group.hub.name
  location            = local.location
  tags                = local.tags

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_key_vault_secret" "hub_diags_name" {
  key_vault_id = azurerm_key_vault.hub.id
  name         = "hub-diags-name"
  value        = azurerm_storage_account.diags.name
  content_type = "storage-name"
}

resource "azurerm_key_vault_secret" "hub_diags_key" {
  key_vault_id = azurerm_key_vault.hub.id
  name         = "hub-diags-key"
  value        = azurerm_storage_account.diags.secondary_access_key
  content_type = "storage-key"
}

resource "azurerm_recovery_services_vault" "hub" {
  name                = var.recovery_vault_name
  resource_group_name = data.azurerm_resource_group.hub.name
  location            = local.location
  tags                = local.tags
  sku                 = "Standard"
  soft_delete_enabled = true
}

resource "azurerm_backup_policy_vm" "default" {
  name                = "default"
  resource_group_name = data.azurerm_resource_group.hub.name
  recovery_vault_name = azurerm_recovery_services_vault.hub.name

  timezone = "UTC"

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 14 //Between 1 & 9999
  }

  retention_weekly {
    count    = 13
    weekdays = ["Wednesday", "Sunday"]
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = ["Last"]
  }

  retention_yearly {
    count    = 3
    weekdays = ["Sunday"]
    weeks    = ["Last"]
    months   = ["January"]
  }
}
