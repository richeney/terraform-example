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
