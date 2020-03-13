output "hub_vnet" {
  value = module.hub.vnet
}

output "hub_subnets" {
  value = module.hub.subnets
}

output "hub_workspace" {
  value = module.hub.workspace
}

output "hub_key_vault" {
  value = module.hub.key_vault
}

output "hub_diags" {
  value = module.hub.diags
}

output "ssh_users" {
  value = module.hub.ssh_users
}

/*
output "vm" {
  value = module.deleteme.vm
}
*/