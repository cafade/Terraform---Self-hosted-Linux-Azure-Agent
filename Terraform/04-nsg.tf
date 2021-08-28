resource "azurerm_network_security_group" "testing-ado-nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.azure_devops_agent_rg.location
  resource_group_name = azurerm_resource_group.azure_devops_agent_rg.name
}

resource "azurerm_network_security_rule" "example" {
  name                        = "ssh-allow"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.azure_devops_agent_rg.name
  network_security_group_name = azurerm_network_security_group.testing-ado-nsg.name
}

resource "azurerm_network_interface_security_group_association" "testing-ado-nic-nsg" {
  network_interface_id      = azurerm_network_interface.testing-ado-nic.id
  network_security_group_id = azurerm_network_security_group.testing-ado-nsg.id
}
