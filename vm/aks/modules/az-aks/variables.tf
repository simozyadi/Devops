

variable "prefix" {
  default     = ""
}

variable "resource_group_name" {
  default     = ""
}

variable "location" {
  default     = ""
}

variable "tags" {
  type        = "map"
  default     = {}
}

variable "admin_username" {
  default     = ""
}

variable "admin_public_ssh_key" {
  default     = ""
}

variable "agents_count" {
  default     = ""
}

variable "agents_size" {
  default     = ""
}

variable "os_disk_size_gb" {
  default     = ""
}

variable "os_type" {
  default     = ""
}

variable "agent_pool_name" {
  default     = ""
}

variable "kubernetes_version" {
  default     = ""
}

variable "service_principal_client_id" {
  default     = ""
}

variable "service_principal_client_secret" {
  default     = ""
}