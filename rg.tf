provider "azurerm" {
        subscription_id = "ff39ad93-bff9-4a64-bb52-565329513d1f"
        client_id = "d48a9aca-df86-4928-9f59-5cade2372f32"
        client_secret = "cT_CgH89K.jP8DHs6TxcQr8a0BWkIB~_p3"
        tenant_id = "9e5c4391-bbca-45ce-84d3-d6fa30c832c3"
        features{}
}



resource "azurerm_resource_group" "rg"{
    name = "my_resource_zabi"
    location = "North Europe"
    tags = {
        environment = "Terraform Lab"
  }
}
