data "azurerm_image" "custom" {
  name                = "myPackerImage"
  resource_group_name = "myResourceGroup"
}

resource "azurerm_public_ip" "public" {
  name                = "cloud"
  resource_group_name = azurerm_resource_group.cloud.name
  location            = azurerm_resource_group.cloud.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = azurerm_resource_group.cloud.location
  resource_group_name = azurerm_resource_group.cloud.name
}

resource "azurerm_network_security_rule" "example" {
  name                        = "http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.cloud.name
  network_security_group_name = azurerm_network_security_group.example.name
}

resource "azurerm_network_interface" "main" {
  name                = "vm-nic"
  location            = azurerm_resource_group.cloud.location
  resource_group_name = azurerm_resource_group.cloud.name
  network_security_group_id = azurerm_network_security_group.example.id

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public.id
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "linux-vm"
  location              = azurerm_resource_group.cloud.location
  resource_group_name   = azurerm_resource_group.cloud.name
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    id = data.azurerm_image.custom.id
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}