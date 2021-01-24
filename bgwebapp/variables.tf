terraform {
  backend          "azurerm"        {}
}

variable "subscription_id" {}
variable "tenant_id" {}

variable "client_id" {}
variable "client_secret" {}
