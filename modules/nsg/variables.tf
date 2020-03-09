variable "resource_group" {
  type = string
}

variable "asgs" {
  description = "List of application security groups"
  type        = list(string)
}


// Can't default protocol to "Tcp" until https://github.com/hashicorp/terraform/issues/19898 is resolved
// This will allow optional and defaulted values in Type Constraints. Also look at allowing ranges at that point,
// and defaulting access, direction and source port range instead of hardcoding.

variable "nsgs" {
  type = list(object({
    name = string
    rules = list(object({
      priority = number
      name     = string
      source   = any
      dest     = any
      ports    = list(number)
      protocol = string
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