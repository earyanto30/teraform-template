# SSH Public Key
resource "azurerm_ssh_public_key" "main" {
  name                = "${var.prefix}-sshkey"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  public_key          = var.ssh_public_key
  tags                = var.tags
}

# Linux Virtual Machine
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size
  tags                  = var.tags

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "${var.prefix}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
    disk_size_gb      = var.os_disk_size_gb
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.prefix}-vm"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = azurerm_ssh_public_key.main.public_key
    }
  }
}