data "vsphere_virtual_machine" "template" {
  count         = var.content_library == null ? 1 : 0
  name          = var.template_name
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

locals {
  // interface_count     = length(var.netmask) #Used for Subnet handeling
  template_disk_count = var.content_library == null ? length(data.vsphere_virtual_machine.template[0].disks) : 0
}

resource "vsphere_virtual_machine" "vm" {
  count            = var.number_of_vms
  # Ensures that the VM name is written in a capital case
  name             = upper("${var.vmname}100${count.index}") 
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.member_datastore.id

  num_cpus = var.number_of_vcpu
  memory   = var.memory
  guest_id = data.vsphere_virtual_machine.template[0].guest_id

  scsi_type = data.vsphere_virtual_machine.template[0].scsi_type

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = data.vsphere_virtual_machine.template[0].disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.template[0].disks.0.thin_provisioned
  }
  dynamic "disk" {
    for_each = var.data_disk
    iterator = terraform_disks
    content {
      label = terraform_disks.key
      size  = lookup(terraform_disks.value, "size_gb", null)
      unit_number = (
        lookup(
          terraform_disks.value,
          "unit_number",
          -1
          ) < 0 ? (
          lookup(
            terraform_disks.value,
            "data_disk_scsi_controller",
            0
            ) > 0 ? (
            (terraform_disks.value.data_disk_scsi_controller * 15) +
            index(keys(var.data_disk), terraform_disks.key) +
            (var.scsi_controller == tonumber(terraform_disks.value["data_disk_scsi_controller"]) ? local.template_disk_count : 0)
            ) : (
            index(keys(var.data_disk), terraform_disks.key) + local.template_disk_count
          )
          ) : (
          tonumber(terraform_disks.value["unit_number"])
        )
      )
      thin_provisioned  = lookup(terraform_disks.value, "thin_provisioned", "true")
      eagerly_scrub     = lookup(terraform_disks.value, "eagerly_scrub", "false")
      datastore_id      = lookup(terraform_disks.value, "datastore_id", null)
      storage_policy_id = lookup(terraform_disks.value, "storage_policy_id", null)
      io_reservation    = lookup(terraform_disks.value, "io_reservation", null)
      io_share_level    = lookup(terraform_disks.value, "io_share_level", "normal")
      io_share_count    = lookup(terraform_disks.value, "io_share_level", null) == "custom" ? lookup(terraform_disks.value, "io_share_count") : null
      disk_mode         = lookup(terraform_disks.value, "disk_mode", null)
    }
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template[0].id

    customize {
      linux_options {
        # Ensures that the hostname is written in a lower case
        host_name = lower("${var.vmname}100${count.index}")
        domain    = var.domain_name
        hw_clock_utc = var.hw_clock_utc
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