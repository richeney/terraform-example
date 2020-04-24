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

output "subnets" {
  value = merge(var.subnets, var.subnet_nsgs)
  // Update this to a dynamic map so that nsg_id can be set to null
}

/*
output "subnets" {
  value = {
    for subnet in local.subnets :
    subnet.name => {
      name           = subnet.name
      address_prefix = subnet.address_prefix
      nsg_id         = subnet.nsg_id
      // id             = azurerm_subnet.subnet[subnet.name].id
    }
  }
}
*/