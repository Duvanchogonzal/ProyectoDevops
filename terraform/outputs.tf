# ============================================================
# Archivo: outputs.tf
# Descripción: Salidas del despliegue DevOps
# ============================================================

output "vm_name_v2" {
  value       = azurerm_linux_virtual_machine.vm_devops_v2.name
  description = "Nombre de la máquina virtual desplegada"
}

output "vm_public_ip_v2" {
  value       = azurerm_public_ip.public_ip_v2.ip_address
  description = "Dirección IP pública asignada a la VM DevOps v2"
}

output "resource_group_v2" {
  value       = azurerm_resource_group.rg_devops_v2.name
  description = "Nombre del grupo de recursos DevOps v2"
}

