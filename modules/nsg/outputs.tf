output "asgs" {
  value = {
    for asg in local.asgs :
    asg => azurerm_application_security_group.asg[asg].id
  }
}

output "nsg_rules" {
  value = local.nsg_rules
}

output "nsgs" {
  value = {
    for nsg in distinct(local.nsg_rules[*].nsg) :
    nsg => azurerm_network_security_group.nsg[nsg].id
  }
}