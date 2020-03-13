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

// Can't default private endpoints to [] until https://github.com/hashicorp/terraform/issues/19898 is resolved

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
    nsg_id         = string
    // private_endpoints = { type = list(string), default = [] }
  }))

  default = []
}

variable "service_endpoints" {
  type        = map
  description = "{ <subnet_name>: [ \"AzureService\" ]} from AzureActiveDirectory, AzureCosmosDB, ContainerRegistry, EventHub, KeyVault, ServiceBus, Sql, Storage and Web."
  default     = {}
}