terraform {
  backend          "azurerm"        {}
}

variable "subscription_id" {}
variable "tenant_id" {}

variable "client_id" {}
variable "client_secret" {}



variable "admin_username" {
    type     = string
    default  = "defaultuser"
}

variable "admin_password" {
    type     = string
    default  = ""
}

variable "location" {
    type     = string
}

variable "rg_tag" {
    type    = string
    default = "production"
}

variable "rg_name" {
    type    = string
 }

variable "vm_count" {
    default  = 1
 }

variable "vm_image_string" {
    type    = string
 }

variable "vm_size" {
    type    = string
    default = "Standard_B1s"
  }
