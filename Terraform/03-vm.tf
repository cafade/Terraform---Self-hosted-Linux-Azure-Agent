# Create Virtual Machine

resource "azurerm_public_ip" "testing-ado-private_ip" {
  name                = var.vm_private_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.azure_devops_agent_rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "testing-ado-nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.azure_devops_agent_rg.location
  resource_group_name = azurerm_resource_group.azure_devops_agent_rg.name

  ip_configuration {
    name                          = "ip"
    subnet_id                     = azurerm_subnet.subnet_name_ado_agent.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_private_ip_address
    public_ip_address_id          = azurerm_public_ip.testing-ado-private_ip.id
  }
}

resource "azurerm_virtual_machine" "testing-ado-vm" {
  name                  = "${var.vm_name}-vm"
  location              = azurerm_resource_group.azure_devops_agent_rg.location
  resource_group_name   = azurerm_resource_group.azure_devops_agent_rg.name
  network_interface_ids = [azurerm_network_interface.testing-ado-nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = var.vm_osdisk_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }


  os_profile {
    computer_name  = "${var.vm_name}-vm"
    admin_username = var.vm_username
    admin_password = random_password.password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}


resource "azurerm_virtual_machine_extension" "update-vm" {
  name                 = "update-vm"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  virtual_machine_id   = azurerm_virtual_machine.testing-ado-vm.id
  # azure keyvault variable as an argument to the bash script
  # NOTE: documentation at https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux#template-deployment
  protected_settings = <<SETTINGS
  {
    "script" : "${filebase64("script.sh")}"
  }
SETTINGS
}
