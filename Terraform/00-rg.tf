# Resource Group
resource "azurerm_resource_group" "azure_devops_agent_rg" {
  name     = var.rg_name
  location = var.location
}
