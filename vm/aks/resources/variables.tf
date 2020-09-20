#Authentication
terraform {
  backend          "azurerm"        {}
}

variable "subscription_id" {}
variable "tenant_id" {}

variable "service_principals" {
  
}


variable "prefix" {
  default = "v1devthanos"
  description = "The prefix for the resources created in the specified Azure Resource Group"
}

variable "location" {
  default     = "westus"
  description = "The location for the AKS deployment"
}

variable "CLIENT_ID" {
  description = "The Client ID (appId) for the Service Principal used for the AKS deployment"
}

variable "CLIENT_SECRET" {
  description = "The Client Secret (password) for the Service Principal used for the AKS deployment"
}

variable "admin_username" {
  default     = "azureuser"
  description = "The username of the local administrator to be created on the Kubernetes cluster"
}

variable "agents_size" {
  default     = "Standard_DS2_v2"
  description = "The default virtual machine size for the Kubernetes agents"
}



variable "agents_count" {
  description = "The number of Agents that should exist in the Agent Pool"
  default     = 4
}

variable "os_disk_size_gb" {
  description = "GB For Az OS disk"
  default     = "100"
}

variable "os_type" {
  description = "linux type pref"
  default     = "Linux"
}

variable "agent_pool_name" {
  description = "The name of the pool which hosting the nodes - must start with miniscule ;)"
  default     = "nodepool"
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to install"
  default     = "1.18.8"
}

variable "public_ssh_key" {
  description = "A custom ssh key to control access to the AKS cluster"
  default     = ""

}

variable "tags" {
  description = "Environment Definition"
  default     = {
    Environment = "Dev"
  }
}

variable "rg_aks" {}

