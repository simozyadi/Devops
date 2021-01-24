# Configure the Azure provider
provider "azurerm" {
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "slotDemo" {
    name = "blue_green_deployments_rg"
    location = "francecentral"
}

resource "azurerm_app_service_plan" "slotDemo" {
    name                = "ServicePlanForBGD"
    location            = azurerm_resource_group.slotDemo.location
    resource_group_name = azurerm_resource_group.slotDemo.name
    kind                = "Linux"
    reserved            = true
    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "slotDemo" {
    name                = "main"
    location            = azurerm_resource_group.slotDemo.location
    resource_group_name = azurerm_resource_group.slotDemo.name
    app_service_plan_id = azurerm_app_service_plan.slotDemo.id
}

resource "azurerm_app_service_slot" "slotDemo" {
    name                = "swap"
    location            = azurerm_resource_group.slotDemo.location
    resource_group_name = azurerm_resource_group.slotDemo.name
    app_service_plan_id = azurerm_app_service_plan.slotDemo.id
    app_service_name    = azurerm_app_service.slotDemo.name
}
