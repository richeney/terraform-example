variable "hub" {
  type        = string
  description = "Used for both the vnet and the resource group, and to prefix resources."
  default     = "hub"
}

variable "hub_vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "location" {
  default = "West Europe"
}

variable "tags" {
  type = object({
    owner         = string
    business_unit = string
    costcode      = number
    downtime      = string
    env           = string
    enforce       = bool
  })

  default = {
    owner         = "Richard Cheney"
    business_unit = "CCoE"
    costcode      = 123456
    downtime      = "03:30 - 04:30"
    env           = "dev"
    enforce       = false
  }
}
