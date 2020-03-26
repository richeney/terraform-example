// For an application

resource "azurerm_resource_group" "spoke1" {
  name     = "spoke1"
  location = var.location
  tags     = var.tags
}

module "spoke1_nsg" {
  source         = "./modules/nsg"
  resource_group = azurerm_resource_group.spoke1.name
  depends        = [azurerm_resource_group.spoke1]

  asgs = [
    "Web",
    "Logic",
    "Database"
  ]

  nsgs = [
    {
      name = "Application1"
      rules = [{
        priority = 100,
        name     = "Spoke1_Internet_Web",
        source   = "Internet",
        dest     = "Web",
        ports    = [80, 443],
        protocol = "Tcp"
        },
        {
          priority = 110,
          name     = "Spoke1_Web_Logic",
          source   = "Web",
          dest     = "Logic",
          ports    = [8443],
          protocol = "*"
        },
        {
          priority = 120,
          name     = "Spoke1_Logic_Database",
          source   = "Logic",
          dest     = "Database",
          ports    = [22, 443],
          protocol = "Tcp"
        }
      ]
    }
  ]
}

module "spoke1_vnet" {
  source = "./modules/vnet"
  depends        = [azurerm_resource_group.spoke1]

  resource_group        = azurerm_resource_group.spoke1.name
  vnet_name             = "spoke1"
  address_space         = ["10.1.1.0/24"]
  subnet_name           = "app1"
  subnet_address_prefix = "10.1.1.0/25"
  hub_id                = module.hub.vnet.id
  // network_security_group_id = null
}


## VM info to be added