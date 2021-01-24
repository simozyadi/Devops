# Configure the Azure provider
provider "azurerm" {
    version = "~>2.0"
    features {}
}

resource "azurerm_resource_group" "ryuBlueGreenDep" {
    name = "iac"
    location = "francecentral"
}

resource "azurerm_app_service_plan" "ryuBlueGreenDep" {
    name                = "ServicePlanForBGD"
    location            = azurerm_resource_group.slotDemo.location
    resource_group_name = azurerm_resource_group.slotDemo.name
    sku {
        tier = "Standard"
        size = "S1"
    }
}

resource "azurerm_app_service" "ryuBlueGreenDep" {
    name                = "blue-app-slot"
    location            = azurerm_resource_group.slotDemo.location
    resource_group_name = azurerm_resource_group.slotDemo.name
    app_service_plan_id = azurerm_app_service_plan.slotDemo.id
}

resource "azurerm_app_service_slot" "ryuBlueGreenDep" {
    name                = "green-app-slot"
    location            = azurerm_resource_group.slotDemo.location
    resource_group_name = azurerm_resource_group.slotDemo.name
    app_service_plan_id = azurerm_app_service_plan.slotDemo.id
    app_service_name    = azurerm_app_service.slotDemo.name
}
