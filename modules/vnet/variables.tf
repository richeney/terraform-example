variable "resource_group" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "ddos" {
  type    = bool
  default = false
}

variable "location" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map
  default = {}
}

variable "address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "dns_servers" {
  type    = list(string)
  default = null
}

variable "subnets" {
  type = map(string)
  description = "Simple map of subnet names to address prefixes"
  default = {}
}

variable "subnet_nsgs" {
  type = map(string)
  description = "Simple map of subnet names to nsg_ids"
  default = {}
}

variable "service_endpoints" {
  type        = map
  description = "{ <subnet_name>: [ \"AzureService\" ]} from AzureActiveDirectory, AzureCosmosDB, ContainerRegistry, EventHub, KeyVault, ServiceBus, Sql, Storage and Web."
  default     = {}
}

variable "hub_id" {
  type        = string
  default     = ""
  description = "Resource ID for hub vnet. Triggers standard hub amd spoke peer."
}

variable "module_depends_on" {
  type    = any
  default = null
}

/*

// Forget these until they make defaults in types available
// https://github.com/hashicorp/terraform/issues/19898

variable "subnet_name" {
  type    = string
  default = "GatewaySubnet"
}

variable "subnet_address_prefix" {
  type    = string
  default = "10.0.0.0/24"
}

variable "network_security_group_id" {
  type    = string
  default = null
}

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
    nsg_id         = string // Explicitly set to null for no nsg
  }))

  default = []
}
*/
