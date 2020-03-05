variable "hub" {
  type = object({
    location       = string
    resource_group = string
    tags = object({
      owner         = string
      business_unit = string
      costcode      = number
      downtime      = string
      env           = string
      enforce       = bool
    })
    vnet = object({
      name          = string
      address_space = list(string)
      dns           = list(string)
    })
    subnets = list(object({
      name           = string
      address_prefix = string
      nsg_id         = string
    }))
    key_vault_name = string
    ssh_public_keys = list(object({
      username            = string
      ssh_public_key_file = string
    }))
    workspace_name              = string
    recovery_vault_name         = string
    diagnostics_storage_account = string
  })
}

/*
variable "resource_group" {
  type    = string
  default = ""
}

variable "location" {
  default = ""
}

variable "tags" {
  type    = map
  default = {}
}

variable "ssh_public_keys" {
  description = "List of Ubuntu users and their public keys"

  type = map(string)

  default = {
    ubuntu = "~/.ssh/id_rsa.pub"
  }
}

variable "key_vault_name" {
  type = string
}

variable "workspace_name" {
  type = string
}

variable "recovery_vault_name" {
  type = string
}

variable "diagnostics_storage_account" {
  type = string
}
*/