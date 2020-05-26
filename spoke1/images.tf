data "azurerm_platform_image" "ubuntu_16_04" {
  location  = var.location
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "16.04-LTS"
}

data "azurerm_platform_image" "ubuntu_18_04" {
  location  = var.location
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "18.04-LTS"
}

data "azurerm_platform_image" "ubuntu_20_04" {
  location  = var.location
  publisher = "Canonical"
  offer     = "UbuntuServer"
  sku       = "20.04-LTS"
}