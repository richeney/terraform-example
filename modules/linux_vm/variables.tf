variable "resource_group" {}

variable "subnet_id" {}

variable "name" {
  default = "myVM"
}

variable "names" {
  // User either name or names. Names has precedence.
  type    = list(string)
  default = []
}

variable "vm_size" {
  default = "Standard_B1ls"
}

variable "storage_account_type" {
  default     = "Standard_LRS"
  description = "Either Standard_LRS (default), StandardSSD_LRS or Premium_LRS."
}

variable "key_vault_id" {
  type = string
}

variable "admin_username" {
  description = "Admin username. Requires matching secret in keyvault with the public key and must be in the list of ssh_users."
  default     = "ubuntu"
}

variable "ssh_users" {
  description = "Set of key vault secrets containing SSH public keys"
  type        = set(string)
}
