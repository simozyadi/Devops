resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.prefix}-aks"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "${var.prefix}"
  kubernetes_version  = "${var.kubernetes_version}"

  linux_profile {
    admin_username = "${var.admin_username}"

    ssh_key {
      # remove any new lines using the replace interpolation function
      key_data = "${replace(var.admin_public_ssh_key, "\n", "")}"
    }
  }

  default_node_pool {
    name            = "${var.agent_pool_name}"
    node_count           = "${var.agents_count}"
    vm_size         = "${var.agents_size}"
  }

  service_principal {
    client_id     = "${var.service_principal_client_id}"
    client_secret = "${var.service_principal_client_secret}"
  }

 

  tags = "${var.tags}"
}
