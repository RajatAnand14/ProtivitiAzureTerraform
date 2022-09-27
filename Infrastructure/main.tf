terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.22.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
  backend "azurerm" {
    resource_group_name  = "TerraformStateRG"
    storage_account_name = "terraformstorage1983"
    container_name       = "terraformstatecontainer"
    key                  = "terraform.tfstate"    
  }
 }

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "random" {
  # Configuration options
}

data "azurerm_client_config" "current" {}

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
    source_address_prefix      = var.source_address_prefix
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
    source_address_prefix      = var.source_address_prefix
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
    source_address_prefix      = var.source_address_prefix
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "TCPHTTPS"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.source_address_prefix
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "TCPSMTP"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "25"
    source_address_prefix      = var.source_address_prefix
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "azuresubnetnsg" {
  count                     = var.vnet_subnet_count
  subnet_id                 = azurerm_subnet.azuresubnet[count.index].id
  network_security_group_id = azurerm_network_security_group.azurensg.id
}

# resource "azurerm_public_ip" "public_ip_win" {
#   name                = var.azure_windows_public_ip
#   resource_group_name = azurerm_resource_group.azurerg.name
#   location            = azurerm_resource_group.azurerg.location
#   allocation_method   = var.azure_public_ip_allocation
#   domain_name_label = "tfwinsrv"
# }

# Create resources for Windows Virtual Machine
# resource "azurerm_network_interface" "azurewindowsnic" {
#   count                     = var.vnet_subnet_count
#   name                = var.azure_windows_nic
#   location            = azurerm_resource_group.azurerg.location
#   resource_group_name = azurerm_resource_group.azurerg.name

#   ip_configuration {
#     name                          = var.azure_nic_ipconfiguration
#     subnet_id                     = azurerm_subnet.azuresubnet[count.index].id
#     private_ip_address_allocation = var.azure_privateip_address_alloc
#     public_ip_address_id = azurerm_public_ip.public_ip_win.id
#   }
# }

# Create Windows Virtual Machine
# resource "azurerm_virtual_machine" "azurewinvm" {
#   count                     = var.vnet_subnet_count
#   name                  = var.azure_winvm_name
#   location              = azurerm_resource_group.azurerg.location
#   resource_group_name   = azurerm_resource_group.azurerg.name
#   network_interface_ids = [azurerm_network_interface.azurewindowsnic[count.index].id]
#   vm_size               = var.azure_winvm_size
#   delete_os_disk_on_termination = true
#   delete_data_disks_on_termination = true

#   storage_image_reference {
#     publisher = var.azure_winvm_publisher
#     offer     = var.azure_winvm_offer
#     sku       = var.azure_winvm_sku
#     version   = var.azure_winvm_server_version
#   }
#   storage_os_disk {
#     name              = var.azure_winvm_server_osdisk
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = var.azure_winvm_server_osdisktype
#   }
#   os_profile {
#     computer_name  = var.azure_winvm_name
#     admin_username = "${azurerm_key_vault_secret.winsrvusername.value}"
#     admin_password = "${azurerm_key_vault_secret.winsrvpassword.value}"
#   }
#   os_profile_windows_config {
#     timezone                  = "GMT Standard Time"
#     provision_vm_agent        = true
#     enable_automatic_upgrades = true
#   }
# }

# Create resources for Linux Virtual Machine
resource "azurerm_public_ip" "public_ip_linux" {
  name                = var.azure_linux_public_ip
  resource_group_name = azurerm_resource_group.azurerg.name
  location            = azurerm_resource_group.azurerg.location
  allocation_method   = var.azure_public_ip_allocation
  domain_name_label = "tflinsrv"
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

# Create Linux virtual machine
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
  admin_username                  = "${azurerm_key_vault_secret.linuxsrvusername.value}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = tls_private_key.linuxvm_ssh.public_key_openssh
      path = "/home/${azurerm_key_vault_secret.linuxsrvusername.value}/.ssh/authorized_keys"
    }
  }
}

# Create Azure Key Vault
resource "azurerm_key_vault" "tfkeyvault" {
  name                        = var.azure_keyvault_name
  location                    = azurerm_resource_group.azurerg.location
  resource_group_name         = azurerm_resource_group.azurerg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = var.azure_keyvault_sku

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "List",
      "Update",
      "Import",
      "Delete",
      "Recover",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List",
      "Backup",
      "Restore"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "random_id" "linuxsrvusername" {
  byte_length = 8
}

resource "azurerm_key_vault_secret" "linuxsrvusername" {
  name         = "TFLinuxServerUserName"  
  value        = "${random_id.linuxsrvusername.id}"
  key_vault_id = azurerm_key_vault.tfkeyvault.id  
}

resource "azurerm_key_vault_secret" "linuxserverkey" {
  name         = "TFLinuxServerKey"  
  value        = tls_private_key.linuxvm_ssh.private_key_pem
  key_vault_id = azurerm_key_vault.tfkeyvault.id
}

# resource "random_id" "winsrvusername" {
#   byte_length = 8
# }

# resource "azurerm_key_vault_secret" "winsrvusername" {
#   name         = "TFWindowsServerUserName"  
#   value        = "${random_id.winsrvusername.id}"
#   key_vault_id = azurerm_key_vault.tfkeyvault.id
# }

# resource "random_password" "winsrvpassword" {
#   length           = 16
#   special          = true  
# }

# resource "azurerm_key_vault_secret" "winsrvpassword" {
#   name         = "TFWindowsServerPassword"  
#   value        = random_password.winsrvpassword.result
#   key_vault_id = azurerm_key_vault.tfkeyvault.id
# }