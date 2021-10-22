data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  count            = var.number_of_vms
  # Ensures that the VM name is written in a capital case
  name             = upper("${var.vmname}100${count.index}") 
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.member_datastore.id

  num_cpus = var.number_of_vcpu
  memory   = var.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = data.vsphere_virtual_machine.template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        # Ensures that the hostname is written in a lower case
        host_name = lower("${var.vmname}100${count.index}")
        domain    = var.domain_name
      }

      network_interface {
        ipv4_address = "${(var.ip_address)[count.index]}"
        ipv4_netmask = var.netmask
      }

      ipv4_gateway    = var.net_gateway
      dns_server_list = var.dns_servers
      dns_suffix_list = [var.domain_name]
    }
  }
}

# Keep virtual machines on separate hosts
resource "vsphere_compute_cluster_vm_anti_affinity_rule" "cluster_vm_anti_affinity_rule" {
  name                = var.affinity_rule_name
  compute_cluster_id  = "${data.vsphere_compute_cluster.compute_cluster.id}"
  virtual_machine_ids = [ for k, v in vsphere_virtual_machine.vm : v.id ]
}