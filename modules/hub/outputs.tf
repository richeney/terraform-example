output "key_vault_id" {
  value = azurerm_key_vault.hub.id
}

output "key_vault_uri" {
  value = azurerm_key_vault.hub.vault_uri
}

output "ssh_users" {
  value = var.hub.ssh_public_keys[*].username
}
