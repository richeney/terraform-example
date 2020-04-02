// For an application

resource "azurerm_resource_group" "spoke1" {
  name     = "spoke1"
  location = var.location
  tags     = var.tags
}

module "spoke1_nsgs" {
  source            = "./modules/nsgs"
  resource_group    = azurerm_resource_group.spoke1.name
  module_depends_on = azurerm_resource_group.spoke1

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
  source            = "./modules/vnet"
  module_depends_on = azurerm_resource_group.spoke1

  resource_group            = azurerm_resource_group.spoke1.name
  vnet_name                 = "spoke1"
  address_space             = ["10.1.1.0/24"]
  subnet_name               = "app1"
  subnet_address_prefix     = "10.1.1.0/25"
  hub_id                    = module.hub_vnet.vnet.id
  network_security_group_id = module.spoke1_nsgs.nsg_ids["Application1"]
}


## VM info to be added