output "vm_name" {
  description = "VM Names"
  value       = vsphere_virtual_machine.vm.*.name
}

output "ip" {
  description = "default ip address of the deployed VM"
  value       = vsphere_virtual_machine.vm.*.default_ip_address
}

output "vm_info" {
  value = tomap({
    "Names" = vsphere_virtual_machine.vm.*.name
    "IP Address" = vsphere_virtual_machine.vm.*.default_ip_address
    })
}