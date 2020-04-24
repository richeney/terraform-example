// For an application

resource "azurerm_resource_group" "spoke1" {
  name     = "spoke1"
  location = var.location
  tags     = var.tags
}

module "spoke1_nsgs" {
  source         = "../modules/nsgs"
  resource_group = azurerm_resource_group.spoke1.name
  location       = azurerm_resource_group.spoke1.location
  tags           = azurerm_resource_group.spoke1.tags

  asgs = [
    "Web",
    "Logic",
    "Database"
  ]

  nsgs = [
    {
      name = "Spoke1_Application1"
      rules = [
        {
          priority = 100,
          name     = "Spoke1_Application1_Internet_to_Web",
          source   = "Internet",
          dest     = "Web",
          ports    = [80, 443],
          protocol = "Tcp"
        },
        {
          priority = 110,
          name     = "Spoke1_Application1_Web_to_Logic",
          source   = "Web",
          dest     = "Logic",
          ports    = [8443],
          protocol = "*"
        },
        {
          priority = 120,
          name     = "Spoke1_Application1_Logic_to_Database",
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
  source         = "../modules/vnet"
  resource_group = azurerm_resource_group.spoke1.name
  location       = azurerm_resource_group.spoke1.location
  tags           = azurerm_resource_group.spoke1.tags

  vnet_name     = "spoke1"
  address_space = ["10.1.1.0/24"]

  subnet_name               = "app1"
  subnet_address_prefix     = "10.1.1.0/25"
  network_security_group_id = module.spoke1_nsgs.nsg_ids["Spoke1_Application1"]

  hub_id = module.hub_vnet.vnet.id
}


## VM info to be added