# provider
provider "azure_rm" {
  version = ""
  subscription_id = ""
  tenant_id = ""
}

# variables
variable VNET_NAME {
  value: "my_tf_vnet"
}

variable VNET_CIDR {
  value: "10.1.0.0/16"
}

variable SUBNET_NAME {
  value: "my_tf_subnet"
}

variable SUBNET_1_CIDR {
  value: "10.1.1.0/24"
}

variable SUBNET_2_CIDR {
  value: "10.1.2.0/24"
}

variable VNET_NAME {
  value: "my_tf_vnet"
}

variable LOCATION {
  value: "west-india"
}

# terraform remote backend to save tfstate
terraform "backend" {
  storage_account: ""
  token_id: ""
  access_id: "" 
}

# resource group
resource "azure_rg" "tf_rg" {
  name: ""
  location: ""

  tags: {
    env: "tf_demo"
  }
}

# vnet
resource "azure_network_vnet" "tf_vnet" {
  name: "my_tf_vnet"
  resource_group: ""
  subscription_id: ""
  resource_group: ""
  location: ""
  vnet_cidr: ""

  tags: {
    env: "tf_demo"
  }
}

# subnets
resource "azure_network_subnet" "tf_subnet_1" {
  name: ""
  resource_group: ""
  location: ""
  subscription_id: ""
  resource_group: ""
  vnet: ""
  subnet_cidr: ""

  tags: {
    env: "tf_demo"
  }
}

resource "azure_network_subnet" "tf_subnet_2" {
  name: ""
  resource_group: ""
  location: ""
  subscription_id: ""
  resource_group: ""
  vnet: ""
  subnet_cidr: ""

  tags: {
    env: "tf_demo"
  }
}

# nsgs
resource "azure_network_security" "tf_nsg_1" {
  name: ""
  resource_group: ""
  location: ""
  subscription_id: ""
  resource_group: ""

  tags: {
    env: "tf_demo"
  }

  # best to keep nsg rules separate so they are reusable
  # keeping it together only for this example
  rule "rule_80" {
    direction: "inbound"
    access: "allow"
    protocol: ""
    src_ip: ""
    src_port: ""
    dest_ip: ""
    dest_port: ""
  }

  rule "rule_443" {
    direction: "inbound"
    access: "allow"
    protocol: ""
    src_ip: ""
    src_port: ""
    dest_ip: ""
    dest_port: ""
  }
}

# vms and associated resources
# lets assume az sets default values for now for nic, ip
resource "azure_vm" "tf_vm" {
  name: ""
  resource_group: ""
  location: ""
  subscription_id: ""
  resource_group: ""
  
  image: "windows"
  size: ""
  cpu: ""
  username: ""
  password: ""

  tags: {
    env: "tf_demo"
  }
}

# storage accounts
resource "azure_storage" "tf_str_acc" {
  name: ""
  resource_group: ""
  location: ""
  subscription_id: ""
  resource_group: ""
  
  account_type: ""
  replication: ""

  tags: {
    env: "tf_demo"
  }
}
