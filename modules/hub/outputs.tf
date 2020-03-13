output "vnet" {
  value = module.vnet.vnet
}

output "subnets" {
  value = module.vnet.subnets
}

output "key_vault" {
  value = {
    name = azurerm_key_vault.hub.name
    id   = azurerm_key_vault.hub.id
    uri  = azurerm_key_vault.hub.vault_uri
  }
}

output "ssh_users" {
  value = var.ssh_public_keys[*].username
}

output "workspace" {
  value = {
    name          = azurerm_log_analytics_workspace.hub.name
    id            = azurerm_log_analytics_workspace.hub.id
    key_vault_key = azurerm_key_vault_secret.hub_workspace_key.name
  }
}

output "diags" {
  value = {
    name          = azurerm_storage_account.diags.name
    id            = azurerm_storage_account.diags.id
    key_vault_key = azurerm_key_vault_secret.hub_diags_key.name
  }
}

output "recovery" {
  value = {
    vault_id                    = azurerm_recovery_services_vault.hub.id
    default_vm_backup_policy_id = azurerm_backup_policy_vm.default.id
  }
}
