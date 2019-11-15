variable "resource_group_name" {
  description = "Your desired azure resource group name"
  type        = "string"
}

variable "platform_name" {
  description = "The name of the cluster that is used for tagging some resources"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = "map"
}

variable "dns_domain_name" {}
variable "master_external_lb_ip_address" {}
variable "router_external_lb_ip_address" {}
variable "bastion_ip_address" {}