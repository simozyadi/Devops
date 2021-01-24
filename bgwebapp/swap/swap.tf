# Configure the Azure provider
provider "azurerm" {
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
    version = "~>2.0"
    features {}
}

# Swap the production slot and the staging slot
resource "azurerm_app_service_active_slot" "ActiveSlot" {
    resource_group_name   = "slotDemoResourceGroup"
    app_service_name      = "slotAppService"
    app_service_slot_name = "slotappServiceSlotOne"
}