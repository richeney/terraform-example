data "azurerm_client_config" "current" {}

locals {
  // Avoid lists of maps as for_each want either sets or maps
  // And dynamic maps using for x in y cause errors in nested modules
  // Convert into a map of maps

  subnets = length(var.subnets) > 0 ? {
    for subnet in var.subnets :
    (subnet.name) => subnet
    } : {
    (var.subnet_name) = {
      name           = var.subnet_name
      address_prefix = var.subnet_address_prefix
      nsg_id         = var.network_security_group_id
    }
  }

  subnet_nsgs = {
    for name, subnet in local.subnets :
    (name) => subnet if subnet.nsg_id != null
  }

  // Only one DDOS Protection Plan per region
  ddos_vnet = toset(var.ddos ? ["Standard"] : [])

  service_endpoints = {
    for subnet in keys(var.service_endpoints) :
    subnet => [
      for service in var.service_endpoints[subnet] :
      "Microsoft.${trimprefix(service, "Microsoft.")}"
    ]
  }
}

resource "azurerm_network_ddos_protection_plan" "ddos" {
  for_each = local.ddos_vnet
  name     = each.value

  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group
  location            = var.location
  tags                = var.tags

  address_space = var.address_space
  dns_servers   = var.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = local.ddos_vnet
    content {
      id     = azurerm_network_ddos_protection_plan.ddos[ddos_protection_plan.value].id
      enable = true
    }
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "subnet" {
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name

  for_each = local.subnets

  name              = each.value.name
  address_prefix    = each.value.address_prefix
  service_endpoints = contains(keys(local.service_endpoints), each.key) ? local.service_endpoints[each.key] : null
}

resource "azurerm_subnet_network_security_group_association" "subnet" {
  for_each = local.subnet_nsgs

  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = each.value.nsg_id
}