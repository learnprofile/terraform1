variable "resource_group_name" {
  description = "Your desired azure resource group name"
  type        = "string"
}

variable "platform_name" {
  description = "The name of the cluster that is used for tagging some resources"
}

variable "openshift_major_version" {}

variable "admin_username" {}
variable "public_key_path" {}
variable "openshift_virtual_network_name" {}

variable "deployment_instance_enabled" {}
variable "deployment_instance_shape" {}

variable "master_instances_count" {}
variable "master_subnet_name" {}
variable "master_nsg_name" {}
variable "master_node_shape" {}
variable "master_availability_set_name" {}

variable "infra_instances_count" {}
variable "infra_subnet_name" {}
variable "infra_nsg_name" {}
variable "infra_node_shape" {}
variable "infra_availability_set_name" {}

variable "worker_instances_count" {}
variable "worker_subnet_name" {}
variable "worker_nsg_name" {}
variable "worker_node_shape" {}
variable "worker_availability_set_name" {}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = "map"
}