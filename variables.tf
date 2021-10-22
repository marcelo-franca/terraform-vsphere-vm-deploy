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

variable "content_library" {
  description = "Name of the content library where the OVF template is stored."
  default     = null
}

## Network Settings
variable "vcenter_network" {
  type        = string
  default     = "VM Network"
  description = "Here you will set the name of your network. By default is VM Network but maybe can be another like Production_NET"
}
variable "ip_address" {
  type        = list
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

## Linux Customization Variables
variable "hw_clock_utc" {
  description = "Tells the operating system that the hardware clock is set to UTC."
  type        = bool
  default     = true
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

#Data Disk section
variable "data_disk" {
  description = "Storage data disk parameter, example"
  type        = map(map(string))
  default     = {}
}

variable "scsi_controller" {
  description = "scsi_controller number for the main OS disk."
  type        = number
  default     = 0
 }