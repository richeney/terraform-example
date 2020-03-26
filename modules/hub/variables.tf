
variable "resource_group" {
  type    = string
  default = "hub"
}

variable "location" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map
  default = {}
}

variable "vnet_name" {
  type    = string
  default = "vnet"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "dns_servers" {
  type        = list(string)
  description = "Example [ '1.1.1.1', '1.0.0.1']"
  default     = null
}

variable "ddos" {
  type        = bool
  description = "Enable DDOS Standard Protection Plan - note that this is circa $3k a month per region."
  default     = false
}

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
    nsg_id         = string
  }))

  default = []
}

variable "service_endpoints" {
  type    = map
  default = null
}

variable "key_vault_name" {
  type        = string
  description = "Max 13 chars, lowercase alphanum or hyphens. Will be suffixed with random string."
  default     = "hub-key-vault"
}

variable "ssh_public_keys" {
  type = list(object({
    username            = string
    ssh_public_key_file = string
  }))

  default = [
    {
      username            = "ubuntu"
      ssh_public_key_file = "~/.ssh/id_rsa.pub"
    }
  ]
}

variable "workspace_name" {
  type        = string
  description = "Needs to be globally unique. Will be suffixed with random string."
  default     = "AzureMonitorLogAnalyticsWorkspace"
}

variable "workspace_retention" {
  type        = number
  description = "Retention in days, between 30 and 730."
  default     = 30
}

variable "recovery_vault_name" {
  type        = string
  description = "Needs to be globally unique. Will be suffixed with random string."
  default     = "AzureRecoveryVault"
}

variable "diagnostics_storage_account" {
  type        = string
  description = "Max 14 chars, lowercase alphanum only. Will be suffixed with random string."
  default     = "vmbootdiags"
}

/*
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
    vnet =
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

*/

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
