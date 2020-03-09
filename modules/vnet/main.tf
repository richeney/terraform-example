data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "vnet" {
  name = var.resource_group
}

locals {
  location = var.location != "" ? var.location : data.azurerm_resource_group.vnet.location

  tags = merge(data.azurerm_resource_group.vnet.tags, var.tags)

  subnets = length(var.subnets) > 0 ? var.subnets : [{
    name           = var.subnet_name
    address_prefix = var.subnet_address_prefix
    nsg_id         = var.network_security_group_id
  }]

  // Only one DDOS Protection Plan per region
  ddos_vnet = var.ddos ? [local.location] : []
}

resource "azurerm_network_ddos_protection_plan" "ddos" {
  for_each = toset(local.ddos_vnet)
  name     = each.value

  resource_group_name = data.azurerm_resource_group.vnet.name
  location            = local.location
  tags                = local.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.vnet.name
  location            = local.location
  tags                = local.tags

  address_space = var.address_space
  dns_servers   = var.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = toset(local.ddos_vnet)
    content {
      id     = azurerm_network_ddos_protection_plan.ddos[ddos_protection_plan.value].id
      enable = true
    }
  }

  /*
  dynamic "subnet" {
    for_each = local.subnets
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.address_prefix
      security_group = subnet.value.nsg_id
    }
  }
  */

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "subnet" {
  resource_group_name  = data.azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  for_each = {
    for subnet in local.subnets :
    subnet.name => subnet.address_prefix
  }

  name           = each.key
  address_prefix = each.value
}

resource "azurerm_subnet_network_security_group_association" "subnet" {
  for_each = {
    for subnet in local.subnets :
    subnet.name => subnet.nsg_id if subnet.nsg_id != null
  }

  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = each.value
}