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
    default  = "westeurope"
}

variable "rg_tag" {
    type    = string
    default = "production"
}

variable "rg_name" {
    type    = string
    default = "vmRG"
 }

variable "vm_count" {
    type    = number
    default  = 1
 }

variable "vm_image_string" {
    type    = string
    default = "OpenLogic/CentOS/7.5/latest"
 }

variable "vm_size" {
    type    = string
    default = "Standard_B1s"
  }
