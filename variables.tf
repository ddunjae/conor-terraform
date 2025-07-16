
//Resource Group
variable "resource_group_name" {
    type = string
    default = "test-conor-rg"
}
variable "location" {
    type = string
    default = "koreacentral"
}
//Virtual Network
variable "vnet_name" {
    type = string
    default = "test-conor-vnet"
}
variable "vnet_address_space" {
  type = list(string)
  default = [ "10.0.0.0/16" ]
}

//Subnet
variable "subnets" {
    type = map(object({
        address_prefixes = list(string)
    }))
    default = {
      "test-snet-1" = {
        address_prefixes = ["10.0.1.0/24"]
      }
      "test-snet-2" = {
        address_prefixes = ["10.0.2.0/24"]
      }
      "test-snet-3" = {
        address_prefixes = ["10.0.3.0/24"]
      }
    }
}
//NSG
variable "nsg_name" {
    type = string
    default = "test-nsg-linux"
}
//Linux VM 변수
variable "linux_vm_name" {
    description = "Linux VM 이름"
    type = string
    default = "test-linux-vm"
}
variable "linux_vm_size" {
    description = "VM SKU"
    type = string
    default = "Standard_B1s"
}
variable "linux_admin_username" {
    description = "Linux VM 관리자 사용자 이름"
    type = string
    default = "azureuser"
}
variable "linux_admin_password" {
    description = "Linux VM 관리자 암호"
    type = string
    default = "P@ssw0rd1234!"
    sensitive = true
}
