
//Resource Group
resource "azurerm_resource_group" "rg" {
    name  = var.resource_group_name
    location = var.location
}
//Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
//Subnet
resource "azurerm_subnet" "snet" {
    for_each = var.subnets
    name = each.key
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = each.value.address_prefixes
}

#NSG - Linux
resource "azurerm_network_security_group" "nsg_linux" {
  name                = "nsg-linux"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_network_security_rule" "ssh" {
  name                        = "ssh"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"  # 추가 필요
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg_linux.name
}

//NSG - Subnet - Linux
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_linux" {
  subnet_id = azurerm_subnet.snet["test-snet-1"].id
  network_security_group_id = azurerm_network_security_group.nsg_linux.id
}
//NIC -Linux
resource "azurerm_network_interface" "linux_nic" {
    name                = "${var.linux_vm_name}-nic"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.snet["test-snet-1"].id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.linux_pip.id

}
}
//Linux - VM
resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                  = var.linux_vm_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.linux_vm_size
  admin_username        = var.linux_admin_username
  admin_password        = var.linux_admin_password
  network_interface_ids = [azurerm_network_interface.linux_nic.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.linux_vm_name}-osdisk"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  disable_password_authentication = false
}
//public IP
resource "azurerm_public_ip" "linux_pip" {
    name = "${var.linux_vm_name}-pip"
    location = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Static"
    sku = "Standard"
}


# NSG - Windows
resource "azurerm_network_security_group" "nsg2" {
  name                = var.nsg_name_2
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
# NSG Rule - Windows
resource "azurerm_network_security_rule" "rdp" {
  name                        = "RDP"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg2.name
}
# NSG -- Subnet - Windows
resource "azurerm_subnet_network_security_group_association" "subnet_nsg2" {
  subnet_id                 = azurerm_subnet.snet["test-snet-2"].id
  network_security_group_id = azurerm_network_security_group.nsg2.id
}

# Public IP - Windows
resource "azurerm_public_ip" "windows_pip" {
  name                = "${var.windows_vm_name}-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Windows VM NIC (with public ip)
resource "azurerm_network_interface" "windows_nic" {
  name                = "${var.windows_vm_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet["test-snet-2"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows_pip.id
  }
}
resource "azurerm_windows_virtual_machine" "windows_vm" {
  name                  = var.windows_vm_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.windows_vm_size
  admin_username        = var.windows_admin_username
  admin_password        = var.windows_admin_password
  network_interface_ids = [azurerm_network_interface.windows_nic.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "${var.windows_vm_name}-osdisk"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}
