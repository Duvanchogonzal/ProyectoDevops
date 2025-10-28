# ============================================================
# Archivo: main.tf
# Descripción: Infraestructura del laboratorio DevOps
# Autor: Duván González
# ============================================================

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.100"
    }
  }

  required_version = ">= 1.5.0"
}

provider "azurerm" {
  features {}
}

# -----------------------------
# 1️⃣ Grupo de recursos
# -----------------------------
resource "azurerm_resource_group" "rg_devops_v2" {
  name     = "rg-proyecto-devops-v2"
  location = "East US"
}

# -----------------------------
# 2️⃣ Red virtual y subred
# -----------------------------
resource "azurerm_virtual_network" "vnet_devops_v2" {
  name                = "vnet-devops-v2"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.rg_devops_v2.location
  resource_group_name = azurerm_resource_group.rg_devops_v2.name
}

resource "azurerm_subnet" "subnet_devops_v2" {
  name                 = "subnet-devops-v2"
  resource_group_name  = azurerm_resource_group.rg_devops_v2.name
  virtual_network_name = azurerm_virtual_network.vnet_devops_v2.name
  address_prefixes     = ["10.1.1.0/24"]
}

# -----------------------------
# 3️⃣ IP pública
# -----------------------------
resource "azurerm_public_ip" "public_ip_v2" {
  name                = "ip-publica-v2"
  location            = azurerm_resource_group.rg_devops_v2.location
  resource_group_name = azurerm_resource_group.rg_devops_v2.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# -----------------------------
# 4️⃣ NSG y reglas
# -----------------------------
resource "azurerm_network_security_group" "nsg_v2" {
  name                = "nsg-devops-v2"
  location            = azurerm_resource_group.rg_devops_v2.location
  resource_group_name = azurerm_resource_group.rg_devops_v2.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
}

# -----------------------------
# 5️⃣ Interfaz de red
# -----------------------------
resource "azurerm_network_interface" "nic_v2" {
  name                = "nic-devops-v2"
  location            = azurerm_resource_group.rg_devops_v2.location
  resource_group_name = azurerm_resource_group.rg_devops_v2.name

  ip_configuration {
    name                          = "nic-ipconfig-v2"
    subnet_id                     = azurerm_subnet.subnet_devops_v2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_v2.id
  }
}

# Asociar NSG con la NIC
resource "azurerm_network_interface_security_group_association" "nsg_nic_assoc_v2" {
  network_interface_id      = azurerm_network_interface.nic_v2.id
  network_security_group_id = azurerm_network_security_group.nsg_v2.id
}

# -----------------------------
# 6️⃣ Máquina virtual
# -----------------------------
resource "azurerm_linux_virtual_machine" "vm_devops_v2" {
  name                  = "vm-devops-v2"
  resource_group_name   = azurerm_resource_group.rg_devops_v2.name
  location              = azurerm_resource_group.rg_devops_v2.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic_v2.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub") # Usa tu llave pública local
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# -----------------------------
# 7️⃣ Salida
# -----------------------------
#output "vm_public_ip_v2" {
#  value = azurerm_public_ip.public_ip_v2.ip_address
#  description = "Dirección IP pública de la VM DevOps v2"
#}
#Borrado por duplicacion en archivo output
