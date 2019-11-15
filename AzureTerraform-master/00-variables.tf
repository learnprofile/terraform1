/*
  Filename: 00-variables.tf
  Synopsis: Terraform input variables and configuration to use azure
  Description: Variables that will be used for creation of a new Vnet and related resources
  Comments: Customize the default fields to necessary values
*/

### Variables for authentication
variable "subscription_id" {
  description = "f3db9121-0ace-436c-88a3-3e91be033ce4"
}


variable "client_id" {
  description = "d3b19b0f-6238-4f41-85c0-477d5e337af8"
}


variable "client_secret" {
  description = "bp@eHJK]RcPxH.hzOUnJcQ?9H0ppS8L5"
}


variable "tenant_id" {
  description = "354d552b-0857-4910-bd2c-f935eddb9a03"
}


### Variables for global config
variable "location" {
  description = "The default Azure region for the resource provisioning"
  default = "West US"
}


variable "resource_group_name" {
  description = "Resource group name that will contain various resources"
  default = "testresourcegroup-pra"
}


variable "user" {
  description =  "user tag to identify similar resources "
  default = "testuser"
}


### Variables for networking
variable "vnet_name" {
  description = "Name for Virtual network"
  default = "terraformtestvnet"
}


variable "subnet1_name" {
  description = "Name for first subnetwork"
  default = "terraformsubnet"
}


variable "subnet2_name" {
  description = "Name for second subnetwork"
  default = "terraformsubnet2"
}


variable "vnet_cidr" {
  description = "CIDR block for Virtual Network"
  default = "1.0.0.0/16"
}


variable "subnet1_cidr" {
  description = "CIDR block for Subnet within a Virtual Network"
  default = "1.0.0.0/24"
}


variable "subnet2_cidr" {
  description = "CIDR block for Subnet within a Virtual Network"
  default = "2.0.0.0/24"
}


### Variables for Storage
variable "storage_account_name" {
  description = "Name for storage account"
  default = "maerskinternetstg"
}


variable "storage_name" {
  description = "Name for storage blob"
  default = "terraform"
}


### Variables for IP and Network Interace Card
variable "public_ip_name" {
  description = "Name for public IP"
  default = "maerskpublicip"
}


variable "network_interface_card_name" {
  description = "name for public Network Interface Card"
  default = "maersknetworkcard"
}


### Variables for Virtual Machine
variable "virtual_machine_name" {
  description = "name for Virtual Machine"
  default = "maersktestvm"
}


variable "virtual_machine_size" {
  description = "size type for Virtual Machine"
  default = "STANDARD_B1S"
}


variable "virtual_machine_username" {
  description = "Enter admin username to SSH into Linux VM"
  default = "USERNAME"
}


variable "virtual_machine_password" {
  description = "Enter admin password to SSH into VM"
  default = "TACOSFORLIFE!"
}
