## vCenter Credentials
variable "vsphere_user" {
  description = "This variable will be used to set a vCenter user"
  type        = string
}

## Server Address
variable "vsphere_server" {
  description = "vCenter IP Address or Domain name"
  type        = string
}

## vCenter Definitons
variable "datacenter_name" {
  description = ""
  type = string
}
variable "vsphere_cluster_name" {
  description = ""
  type = string
}

variable "vsan_datastore_name" {
  description = ""
  type = string
}
variable "resource_pool_name" {
  description = ""
  type = string
}

## CentOS Template
variable "template_name" {
  description = "Linux Template used on DataCenter"
  type        = string
}

## Virtual Machine Settings 
variable "vmname" {
  type        = string
  description = "Name of the VM that will be created"
}
variable "number_of_vms" {
  type        = number
  default     = 1
  description = "Amount of VMs that will be created"
}
variable "number_of_vcpu" {
  type        = number
  default     = 1
  description = "Amount of vCPU that the VM will be uses"
}
variable "memory" {
  type        = number
  default     = 1024
  description = "Amount of memory that the VM will be uses"
}
variable "affinity_rule_name" {
  description = ""
  type = string
}

## Network Settings
variable "vcenter_network" {
  type        = string
  default     = "VM Network"
  description = "Here you will set the name of your network. By default is VM Network but maybe can be another like Production_NET"
}
variable "ip_address" {
  type        = string
  description = "IP address. The last octets are added automatically"
}
variable "netmask" {
  type        = number
  default     = 24
  description = "Default netmask is 255.255.255.0"
}
variable "net_gateway" {
  type        = string
  description = "Network Gateway"
}
variable "dns_servers" {
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
  description = "List of DNS Servers"
}
variable "domain_name" {
  type        = string
  description = "Domain of your local network"
}