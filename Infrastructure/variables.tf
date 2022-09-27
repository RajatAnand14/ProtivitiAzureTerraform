####################################################
# INPUT VARIABLES FOR RESOURE GROUP
###################################################
variable "rg_name" {
  description = "Azure Resource Group Name"
  type    = string
  default = "TerraformRG"
}

variable "rg_location" {
  description = "Azure Resource Group Location"

  type    = string
  default = "East US"
}

####################################################
# INPUT VARIABLES FOR AZURE VIRTUAL NETWORK
###################################################
variable "azure_vnetname" {
  description = "Azure Virtual Network Name"
  type    = string
  default = "TerraformVnet"
}

variable "azure_vnet_cidr" {
  description = "Azure Vnet CIDR Block"
  type    = string
  default = "10.0.0.0/16"
}

variable "azure_subnet" {
  description = "Azure Subnet Details"
  type    = string
  default = "TerraformSubnet"
}

variable "vnet_subnet_count" {
  type        = number
  description = "Number of subnets to create in Virtual Network"
  default     = 1
}

variable "azure_nsg" {
  description = "Azure Network Security Group"
  type    = string
  default = "TerraformNSG"
}

variable "azure_windows_public_ip" {
  description = "Azure Windows Public IP"
  type    = string
  default = "TerraformWindowsPublicIP"
}

variable "azure_public_ip_allocation" {
  description = "Azure Public IP Allocation"
  type    = string
  default = "Static"
}

variable "azure_windows_nic" {
  description = "Azure Network Interface"
  type    = string
  default = "TerraformWindowsNIC"
}


variable "azure_nic_ipconfiguration" {
  description = "Azure Network Interface IP Configuration"
  type    = string
  default = "internal"
}

variable "azure_privateip_address_alloc" {
  description = "Azure Private IP Address Allocation"
  type    = string
  default = "Dynamic"
}


variable "source_address_prefix" {
  description = "Source Machine External IP V4 Address"
  type = string
  default = "73.168.172.43"
}

####################################################
# INPUT VARIABLES FOR AZURE WINDOWS VM
###################################################

variable "azure_winvm_name" {
  description = "Azure Windows Vm Name"
  type    = string
  default = "tf-win-vm-001"
}

variable "azure_winvm_size" {
  description = "Azure Windows Vm Size"
  type    = string
  default = "Standard_D2s_v3"
}


variable "azure_winvm_publisher" {
  description = "Azure Windows Vm Publisher"
  type    = string
  default = "MicrosoftWindowsServer"
}

variable "azure_winvm_offer" {
  description = "Azure Windows Vm Offer"
  type    = string
  default = "WindowsServer"
}

variable "azure_winvm_sku" {
  description = "Azure Windows Vm SKU"
  type    = string
  default = "2019-Datacenter"
}

variable "azure_winvm_server_version" {
  description = "Azure Windows Vm Server Version"
  type    = string
  default = "latest"
}

variable "azure_winvm_server_osdisk" {
  description = "Azure Windows Vm Server OS Disk"
  type    = string
  default = "terraformwinvmosdisk"
}

variable "azure_winvm_server_osdisktype" {
  description = "Azure Windows Vm Server OS Disk Type"
  type    = string
  default = "StandardSSD_LRS"
}


####################################################
# INPUT VARIABLES FOR AZURE LINUX VM
###################################################

variable "azure_linux_nic" {
  description = "Azure Network Interface"
  type    = string
  default = "TerraformLinuxNIC"
}

variable "azure_linuxvm_name" {
  description = "Azure Linux Vm Name"
  type    = string
  default = "tf-linux-vm-001"
}

variable "azure_linuxvm_size" {
  description = "Azure Linux Vm Size"
  type    = string
  default = "Standard_D4as_v4"
}

variable "azure_linuxvm_publisher" {
  description = "Azure Linux Vm Publisher"
  type    = string
  default = "Canonical"
}

variable "azure_linuxvm_offer" {
  description = "Azure Linux Vm Offer"
  type    = string
  default = "0001-com-ubuntu-server-focal"
}

variable "azure_linuxvm_sku" {
  description = "Azure Linux Vm SKU"
  type    = string
  default = "20_04-lts-gen2"
}

variable "azure_linuxvm_server_version" {
  description = "Azure Linux Vm Server Version"
  type    = string
  default = "latest"
}

variable "azure_linuxvm_server_osdisk" {
  description = "Azure Linux Vm Server OS Disk"
  type    = string
  default = "terraformlinuxmosdisk"
}

variable "azure_linuxvm_server_osdisktype" {
  description = "Azure Linux Vm Server OS Disk Type"
  type    = string
  default = "Standard_LRS"
}

variable "azure_linux_public_ip" {
  description = "Azure Linux Public IP"
  type    = string
  default = "TerraformLinuxPublicIP"
}

variable "azure_linux_srv_username" {
  description = "Azure Linux Server User Name"
  type    = string
  default = "root"
}


####################################################
# INPUT VARIABLES FOR AZURE KEY VAULT
###################################################
variable "azure_keyvault_name" {
  description = "Azure Key Vault Name"
  type    = string
  default = "ProtivitiTFKeyVault"
}

variable "azure_keyvault_sku" {
  description = "Azure Key Vault SKU Type"
  type    = string
  default = "standard"
}

####################################################
# INPUT VARIABLES FOR AZURE STORAGE ACCOUNT
###################################################
variable "azure_storage_name" {
  description = "Azure Storage Account Name"
  type    = string
  default = "TFStorageAccount1983"
}

variable "azure_storage_account_kind" {
  description = "Azure Storage Account Kind"
  type    = string
  default = "StorageV2"
}

variable "azure_storage_account_tier" {
  description = "Azure Storage Account Tier"
  type    = string
  default = "Standard"
}

variable "azure_storage_access_tier" {
  description = "Azure Storage Account Access Tier"
  type    = string
  default = "Hot"
}

variable "azure_storage_replication_type" {
  description = "Azure Storage Account Replication Type"
  type    = string
  default = "LRS"
}

variable "azure_storage_container_name" {
  description = "Azure Storage Account Container Name"
  type    = string
  default = "tfstatecontainer1983"
}