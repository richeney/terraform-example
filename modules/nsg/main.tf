data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "nsg" {
  name = var.resource_group
}

locals {
  location = var.location != "" ? var.location : data.azurerm_resource_group.nsg.location

  tags = merge(data.azurerm_resource_group.nsg.tags, var.tags)

  // Is there a way to derive this safely? Add in PaaS services?
  service_tags = [
    "VirtualNetwork",
    "AzureLoadBalancer",
    "Internet"
  ]

  << YOU ARE HERE >>
}

resource "azurerm_application_security_group" "asg" {
  resource_group_name = data.azurerm_resource_group.nsg.name
  location            = local.location
  tags                = local.tags

  for_each = toset(var.asgs)
  name     = each.value

  lifecycle {
    ignore_changes = [tags]
  }
}