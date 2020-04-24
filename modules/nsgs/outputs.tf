output "asgs" {
  value = var.asgs
}

output "nsg_rules" {
  value = local.nsg_rules
}

output "nsg_ids" {
  value = {
    for nsg in distinct(local.nsg_rules[*].nsg) :
    (nsg) => azurerm_network_security_group.nsg[nsg].id
  }
}