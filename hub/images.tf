data "azurerm_image" "ubuntu" {
  resource_group_name = "images"
  name                = "ubuntu"
}

data "azurerm_shared_image_gallery" "customImages" {
  resource_group_name = "images"
  name                = "customImages"
}

data "azurerm_shared_image" "ubuntuBase" {
  resource_group_name = "images"
  gallery_name        = "customImages"
  name                = "ubuntuBase"
}

/*
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
*/
