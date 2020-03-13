provider "azurerm" {
  version = "= 2.0.0"
  features {}
}

resource "azurerm_resource_group" "aci" {
  name     = "azure-citadel-terraform-lab"
  location = "West Europe"
  tags = {
    environment = "training"
  }
}

resource "azurerm_container_group" "aci" {
  name                = "hello-world"
  location            = azurerm_resource_group.aci.location
  resource_group_name = azurerm_resource_group.aci.name
  tags                = azurerm_resource_group.aci.tags

  ip_address_type = "public"
  // dns_name_label      = "azure-citadel-terraform-richeney"
  os_type = "Linux"

  container {
    name   = "hello-world"
    image  = "microsoft/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  container {
    name   = "sidecar"
    image  = "microsoft/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }
}
