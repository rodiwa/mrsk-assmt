# general idea is to create various objects (az resources) here and then bind them together
# start with single tf file and add your entire infra here, w variables, etc in 1 file
# then refactor your file for reusability - make separate variables, modules for
# repeating resources,use functions, etc.
# lastly, clean up code
# I am keeping all code in 1 file here for simple readability

# provider
provider "azure_rm" {
  version = ""
  subscription_id = ""
  tenant_id = ""

  features {

  }
}

# variables
variable RG_NAME {
  value = "my_rg"
}

variable VNET_NAME {
  value = "my_tf_vnet"
}

variable VNET_CIDR {
  value = "10.1.0.0/16"
}

variable SUBNET_NAME_1 {
  value = "my_tf_subnet_1"
}

variable SUBNET_NAME_2 {
  value = "my_tf_subnet_2"
}

variable SUBNET_1_CIDR {
  value = "10.1.1.0/24"
}

variable SUBNET_2_CIDR {
  value = "10.1.2.0/24"
}

variable VNET_NAME {
  value = "my_tf_vnet"
}

variable LOCATION {
  value = "west-india"
}

variable DEFAULT_TAG {
  value = "tf_demo"
}

variable NSG_NAME {
  value = "tf_my_nsg"
}

variable WIN_VM_NAME_1 {
  value = "tf_my_win_vm_1"
}

variable WIN_VM_NAME_2 {
  value = "tf_my_win_vm_2"
}

variable WIN_NIC_NAME_1 {
  value = "tf_nic_1"
}

variable WIN_NIC_NAME_2 {
  value = "tf_nic_2"
}

# terraform remote backend to save tfstate
terraform "backend" {
  storage_account = ""
  token_id = ""
  access_id = "" 
}

# resource group
resource "azurerm_resource_group" "tf_rg" {
  name = var.RG_NAME
  location = var.LOCATION

  tags: {
    env = var.DEFAULT_TAG
  }
}

# vnet
resource "azurerm_virtual_network" "tf_vnet" {
  name = var.VNET_NAME
  resource_group_name = azurerm_resource_group.tf_rg.name
  location = azurerm_resource_group.tf_rg.location
  address_space = [var.VNET_CIDR]

  # created subnets separately below
  # we can define NSG before we define subnets and bind them here but ques doesn't ask for specifically
  # subnet {
  #   name: "subnet1"
  #   address_prefix: var.SUBNET_1_CIDR
  # }

  # subnet {
  #   name: "subnet2"
  #   address_prefix: var.SUBNET_2_CIDR
  # }

  tags: {
    env = var.DEFAULT_TAG
  }
}

# subnets
# TODO: can use for-each or count-index here as this is mostly repeating code
resource "azure_network_subnet" "tf_subnet_1" {
  name = var.SUBNET_NAME_1
  resource_group_name = azurerm_resource_group.tf_rg.name
  location = azurerm_resource_group.tf_rg.location
  virtual_network_name = azurerm_virtual_network.tf_vnet.name
  address_prefixes = var.SUBNET_1_CIDR

  tags: {
    env = var.DEFAULT_TAG
  }
}

resource "azure_network_subnet" "tf_subnet_2" {
  name = var.SUBNET_NAME_2
  resource_group_name = azurerm_resource_group.tf_rg.name
  location = azurerm_resource_group.tf_rg.location
  virtual_network_name = azurerm_virtual_network.tf_vnet.name
  address_prefixes = var.SUBNET_2_CIDR

  tags: {
    env = var.DEFAULT_TAG
  }
}

# nsgs
resource "azurerm_network_security_group" "tf_nsg" {
  name = var.NSG_NAME
  resource_group_name = azurerm_resource_group.tf_rg.name
  location = azurerm_resource_group.tf_rg.location
  subscription_id = ""

  tags: {
    env = var.DEFAULT_TAG
  }

  # best to keep nsg rules separate so they are reusable
  # keeping it together only for this example
  security_rule  {
    name = "rule_80"
    priority: "100"
    direction = "Inbound"
    access = "Allow"
    protocol = "TCP"
    src_ip = "*"
    src_port = "80"
    dest_ip = "*"
    dest_port = "80"
  }

  security_rule  {
    name = "rule_443"
    priority: "300"
    direction = "Inbound"
    access = "Allow"
    protocol = "TCP"
    src_ip = "*"
    src_port = "443"
    dest_ip = "*"
    dest_port = "443"
  }
}

# win in each subnet -> create subnet -> create nic + attach to subnet + attach nic to VM
# TODO: can use for-each or count-index here as this is mostly repeating code
resource "azurerm_network_interface" "tf_my_nic_1" {
  name = var.WIN_NIC_NAME_1
  resource_group_name = azurerm_resource_group.tf_rg.name
  location = azurerm_resource_group.tf_rg.location

  ip_configuration {
    subnet_id = azure_network_subnet.tf_subnet_1.id
  }
}

resource "azurerm_network_interface" "tf_my_nic_2" {
  name = var.WIN_NIC_NAME_2
  resource_group_name = azurerm_resource_group.tf_rg.name
  location = azurerm_resource_group.tf_rg.location

  ip_configuration {
    subnet_id = azure_network_subnet.tf_subnet_2.id
  }
}

# vms and associated resources
# TODO: can use for-each or count-index here as this is mostly repeating code
resource "azurerm_windows_virtual_machine" "tf_win_vm_1" {
  name = var.WIN_VM_NAME_1
  resource_group_name = azurerm_resource_group.tf_rg.name
  location = azurerm_resource_group.tf_rg.location
  
  size = "Standard"
  admin_username = "adminuser"
  admin_password = "password"

  # left empty as i had to refer this from docs
  source_image_reference {

  }

  # left empty as i had to refer this from docs
  os_disk {

  }

  tags: {
    env = var.DEFAULT_TAG
  }
}

resource "azurerm_windows_virtual_machine" "tf_win_vm_2" {
  name = var.WIN_VM_NAME_2
  resource_group_name = azurerm_resource_group.tf_rg.name
  location = azurerm_resource_group.tf_rg.location
  
  size = "Standard"
  admin_username = "adminuser"
  admin_password = "password"

  # left empty as i had to refer this from docs
  source_image_reference {

  }

  # left empty as i had to refer this from docs
  os_disk {

  }

  tags: {
    env = var.DEFAULT_TAG
  }
}

# storage accounts
resource "azure_storage" "tf_str_acc" {
  name = ""
  resource_group_name = azurerm_resource_group.tf_rg.name
  location = azurerm_resource_group.tf_rg.location
  subscription_id = ""
  
  account_type = ""
  replication = ""

  tags: {
    env = var.DEFAULT_TAG
  }
}
