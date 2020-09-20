# Providers
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${lookup(var.service_principals[0], "Application_Id")}"
  client_secret   = "${lookup(var.service_principals[0], "Application_Secret")}"
  tenant_id       = "${var.tenant_id}"
  version         = "2.28"
  features {} 
}




####################################################
##########              AKS               ##########
####################################################

data "azurerm_resource_group" "rg_aks" {
    name     = "${var.rg_aks}"
}

module "ssh-key" {
  source         = "../modules/ssh-key"
  public_ssh_key = "${var.public_ssh_key}"
}

module "kubernetes" {
  source                          = "../modules/az-aks"
  prefix                          = "${var.prefix}"
  resource_group_name             = "${data.azurerm_resource_group.rg_aks.name}"
  location                        = "${data.azurerm_resource_group.rg_aks.location}"
  admin_username                  = "${var.admin_username}"
  admin_public_ssh_key            = "${var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key}"
  agents_size                     = "${var.agents_size}"
  agents_count                    = "${var.agents_count}"
  kubernetes_version              = "${var.kubernetes_version}"
  service_principal_client_id     = "${var.CLIENT_ID}"
  service_principal_client_secret = "${var.CLIENT_SECRET}"
  agent_pool_name                 = "${var.agent_pool_name}"
}
