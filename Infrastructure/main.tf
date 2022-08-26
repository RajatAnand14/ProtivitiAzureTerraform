terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "6df8fca1-506f-4b84-99c3-8a57bb986407"
  client_id       = "a27e82f8-3d7a-4bf6-b6da-777a186b2491"
  client_secret   = "Tak8Q~iOK3MK2ewqko2hgepbyO.cp~NNEwwqbbhy"
  tenant_id       = "978794b6-9c6b-4307-ada4-42e472e0e336"  
}

# Create a resource group
resource "azurerm_resource_group" "azurerg" {
  name     = var.rg_name
  location = var.rg_location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "azurevnet" {
  name                = var.azure_vnetname
  resource_group_name = azurerm_resource_group.azurerg.name
  location            = azurerm_resource_group.azurerg.location
  address_space       = [var.azure_vnet_cidr]
}

resource "azurerm_subnet" "azuresubnet" {
  count                = var.vnet_subnet_count
  name                 = var.azure_subnet
  resource_group_name  = azurerm_resource_group.azurerg.name
  virtual_network_name = azurerm_virtual_network.azurevnet.name
  address_prefixes     = [cidrsubnet(var.azure_vnet_cidr, 8, count.index)]
}

resource "azurerm_network_security_group" "azurensg" {
  name                = var.azure_nsg
  location            = azurerm_resource_group.azurerg.location
  resource_group_name = azurerm_resource_group.azurerg.name

  security_rule {
    name                       = "TCPHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "76.36.81.133/32"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "TCPRDP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "76.36.81.133/32"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "TCPSSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "76.36.81.133/32"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "azuresubnetnsg" {
  count                     = var.vnet_subnet_count
  subnet_id                 = azurerm_subnet.azuresubnet[count.index].id
  network_security_group_id = azurerm_network_security_group.azurensg.id
}

resource "azurerm_public_ip" "public_ip_win" {
  name                = var.azure_windows_public_ip
  resource_group_name = azurerm_resource_group.azurerg.name
  location            = azurerm_resource_group.azurerg.location
  allocation_method   = var.azure_public_ip_allocation
}

# Create resources for Windows Virtual Machine
resource "azurerm_network_interface" "azurewindowsnic" {
  count                     = var.vnet_subnet_count
  name                = var.azure_windows_nic
  location            = azurerm_resource_group.azurerg.location
  resource_group_name = azurerm_resource_group.azurerg.name

  ip_configuration {
    name                          = var.azure_nic_ipconfiguration
    subnet_id                     = azurerm_subnet.azuresubnet[count.index].id
    private_ip_address_allocation = var.azure_privateip_address_alloc
    public_ip_address_id = azurerm_public_ip.public_ip_win.id
  }
}

resource "azurerm_virtual_machine" "azurewinvm" {
  count                     = var.vnet_subnet_count
  name                  = var.azure_winvm_name
  location              = azurerm_resource_group.azurerg.location
  resource_group_name   = azurerm_resource_group.azurerg.name
  network_interface_ids = [azurerm_network_interface.azurewindowsnic[count.index].id]
  vm_size               = var.azure_winvm_size
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.azure_winvm_publisher
    offer     = var.azure_winvm_offer
    sku       = var.azure_winvm_sku
    version   = var.azure_winvm_server_version
  }
  storage_os_disk {
    name              = var.azure_winvm_server_osdisk
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.azure_winvm_server_osdisktype
  }
  os_profile {
    computer_name  = var.azure_winvm_name
    admin_username = var.azure_win_admin_username
    admin_password = var.azure_win_admin_password
  }
  os_profile_windows_config {
    timezone                  = "GMT Standard Time"
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
}

# Create resources for Linux Virtual Machine
resource "azurerm_public_ip" "public_ip_linux" {
  name                = var.azure_linux_public_ip
  resource_group_name = azurerm_resource_group.azurerg.name
  location            = azurerm_resource_group.azurerg.location
  allocation_method   = var.azure_public_ip_allocation
}

resource "azurerm_network_interface" "azurelinuxsnic" {
  count                     = var.vnet_subnet_count
  name                = var.azure_linux_nic
  location            = azurerm_resource_group.azurerg.location
  resource_group_name = azurerm_resource_group.azurerg.name

  ip_configuration {
    name                          = var.azure_nic_ipconfiguration
    subnet_id                     = azurerm_subnet.azuresubnet[count.index].id
    private_ip_address_allocation = var.azure_privateip_address_alloc
    public_ip_address_id = azurerm_public_ip.public_ip_linux.id
  }
}

resource "tls_private_key" "linuxvm_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create virtual machine
resource "azurerm_virtual_machine" "azurelinuxvm" {
  count                     = var.vnet_subnet_count
  name                  = var.azure_linuxvm_name
  location              = azurerm_resource_group.azurerg.location
  resource_group_name   = azurerm_resource_group.azurerg.name
  network_interface_ids = [azurerm_network_interface.azurelinuxsnic[count.index].id]
  vm_size                  = var.azure_linuxvm_size
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.azure_linuxvm_publisher
    offer     = var.azure_linuxvm_offer
    sku       = var.azure_linuxvm_sku
    version   = var.azure_linuxvm_server_version
  }

  storage_os_disk {
    name                 = var.azure_linuxvm_server_osdisk
    caching              = "ReadWrite"
    create_option = "FromImage"   
    managed_disk_type = var.azure_linuxvm_server_osdisktype
  }
  os_profile {
  computer_name                   = var.azure_linuxvm_name
  admin_username                  = var.azure_linux_admin_username 
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.linuxvm_ssh.public_key_openssh
      path = "/home/${var.azure_linux_admin_username}/.ssh/authorized_keys"
    }
  }
}
