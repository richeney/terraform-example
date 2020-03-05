output "vnet" {
  value = {
    id              = azurerm_virtual_network.vnet.id
    subscription_id = data.azurerm_client_config.current.subscription_id
    resource_group  = azurerm_virtual_network.vnet.resource_group_name // azurerm_virtual_network.vnet.resource_group
    name            = azurerm_virtual_network.vnet.name                // var.vnet_name
    address_space   = azurerm_virtual_network.vnet.address_space
    dns             = azurerm_virtual_network.vnet.dns_servers
  }

  /* Type constraint for use with variable definitions
  vnet = object({
    id                = string
    subscription_id   = string
    resource_group    = string
    name              = string
    address_space     = list(string)
    dns               = list(string)
  })
  */
}

/*
output "subnets" {
  for_
  value = azurerm
}
*/