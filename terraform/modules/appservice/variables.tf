
variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "rg_location" {
  type        = string
  description = "Resource group location"
}

variable "fe_port" {
  type        = number
  description = "Frontend port"
}

variable "be_port" {
  type        = number
  description = "Backend port"
}

variable "db_server" {
  type        = string
  description = "Database server FQDN"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_user" {
  type        = string
  description = "Database username"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password"
}

variable "author" {
  type        = string
  description = "Author name"
  default     = "terraform"
}

variable "resource_prefix" {
  type        = string
  description = "Resource prefix"
  default     = "devops-tf"
}

variable "subnet_fe_id" {
  type        = string
  description = "ID of frontend subnet"
}

variable "subnet_be_id" {
  type        = string
  description = "ID of backend subnet"
}

variable "subnet_agw_id" {
  type        = string
  description = "ID of AGW subnet"
}

variable "agw_ip" {
  type        = string
  description = "IP of Application Gateway"
}

variable "fe_image_name_and_tag" {
  type        = string
  description = "Frontend image: username/image:tag"
}

variable "be_image_name_and_tag" {
  type        = string
  description = "Backend image: username/image:tag"
}
