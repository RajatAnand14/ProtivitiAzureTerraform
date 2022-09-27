output "tls_private_key" {
  value     = tls_private_key.linuxvm_ssh.private_key_openssh
  sensitive = true
}

output "linuxsrvusername" {
  value     = azurerm_key_vault_secret.linuxsrvusername.value
  sensitive = true
}

output "linuxsrvpublicip" {
  value     = azurerm_public_ip.public_ip_linux.ip_address
}

output "linuxsrvfqdn" {
  value     = azurerm_public_ip.public_ip_linux.fqdn
}