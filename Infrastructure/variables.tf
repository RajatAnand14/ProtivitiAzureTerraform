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
  default = "Dynamic"
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

variable "azure_winvm_name" {
  description = "Azure Windows Vm Name"
  type    = string
  default = "TerraformWinVM"
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

### Linux Input variables ######
variable "azure_linux_nic" {
  description = "Azure Network Interface"
  type    = string
  default = "TerraformLinuxNIC"
}

variable "azure_linuxvm_name" {
  description = "Azure Windows Vm Name"
  type    = string
  default = "TerraformLinuxVM"
}

variable "azure_linuxvm_size" {
  description = "Azure Linux Vm Size"
  type    = string
  default = "Standard_D2s_v3"
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

variable "azure_linux_admin_username" {
  description = "Azure Linux Admin User Name"
  type    = string
  default = "tfadmin"
}







