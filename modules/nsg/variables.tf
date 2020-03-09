variable "resource_group" {
  type = string
}

variable "asgs" {
  description = "List of application security groups"
  type        = list(string)
}


variable "nsgs" {
  type = list(object({
    name = string
    rules = list(object({
      priority = number
      name     = string
      source   = any
      dest     = any
      ports    = list(number)
    }))
  }))
}


variable "prefix" {
  description = "Optional prefix for all resources to be created"
  type        = string
  default     = ""
}

variable "location" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map
  default = {}
}