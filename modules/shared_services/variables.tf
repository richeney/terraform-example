
variable "resource_group" {
  type = string
}

variable "location" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map
  default = {}
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

variable "module_depends_on" {
  type    = any
  default = null
}