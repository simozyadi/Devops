terraform {
  backend          "azurerm"        {}
}

variable "subscription_id" {}
variable "tenant_id" {}

variable "client_id" {}
variable "client_secret" {}

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
    default = "goapprg"
 }


