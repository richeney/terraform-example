output "hub_vnet" {
  value = module.hub_vnet.vnet
}

output "hub_subnets" {
  value = module.hub_vnet.subnets
}

output "hub_workspace" {
  value = module.shared_services.workspace
}

output "hub_key_vault" {
  value = module.shared_services.key_vault
}

output "hub_diags" {
  value = module.shared_services.diags
}

output "ssh_users" {
  value = module.shared_services.ssh_users
}
