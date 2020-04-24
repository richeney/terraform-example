output "asgs" {
  value = module.spoke1_nsgs.asgs
  // value = {
  //   for asg in local.asgs :
  //   (asg) => azurerm_application_security_group.asg[(asg)].id
  // }
}

output "nsg_rules" {
  value = module.spoke1_nsgs.nsg_rules
}

/*
output "nsg_ids" {
  value = module.spoke1_nsgs.nsg_ids
}
*/