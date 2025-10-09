variable "rg_name" {
  description = "Resource Group Name"
  type        = string
}

variable "rg_location" {
  description = "Resource Group Location"
  type        = string
}

variable "resource_prefix" {
  description = "Prefix for resources"
  type        = string
}

variable "author" {
  description = "Author name for naming"
  type        = string
}

variable "db_admin" {
  description = "Database admin username"
  type        = string
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

variable "vnet_id" {
  description = "VNet ID for Private DNS link"
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
}

