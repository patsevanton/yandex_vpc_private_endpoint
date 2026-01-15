variable "name" {
  description = "The resource name."
  type        = string
  default     = null
}

variable "description" {
  description = "The resource description."
  type        = string
  default     = null
}

variable "network_id" {
  description = "ID of the network which private endpoint belongs to."
  type        = string
}

variable "folder_id" {
  description = "The folder identifier that resource belongs to. If it is not provided, the default provider folder-id is used."
  type        = string
  default     = null
}

variable "labels" {
  description = "A set of key/value label pairs which assigned to resource."
  type        = map(string)
  default     = {}
}


variable "dns_options" {
  description = "Private endpoint DNS options block."
  type = object({
    private_dns_records_enabled = bool
  })
  default = null
}

variable "endpoint_address" {
  description = "Private endpoint address specification block. Only one of address_id or subnet_id + address arguments can be specified."
  type = object({
    subnet_id  = optional(string)
    address    = optional(string)
    address_id = optional(string)
  })
  default = null
}

variable "timeouts" {
  description = "Timeout configuration for create, update, and delete operations."
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}
