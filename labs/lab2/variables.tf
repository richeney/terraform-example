variable "location" {
  type    = string
  default = "westeurope"
}

variable "resource_group_name" {
  type    = string
  default = "azure-citadel-terraform-labs"
}

variable "tags" {
  type = map
  default = {
    environment = "training"
  }
}