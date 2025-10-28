# ============================================================
# Archivo: variables.tf
# Descripción: Variables para el despliegue del laboratorio DevOps 
# ============================================================

variable "location" {
  description = "Región de Azure donde se desplegarán los recursos"
  type        = string
  default     = "East US"
}

variable "admin_username" {
  description = "Usuario administrador de la máquina virtual"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Ruta local al archivo de clave pública SSH"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vm_size" {
  description = "Tamaño de la máquina virtual"
  type        = string
  default     = "Standard_B1s"
}

