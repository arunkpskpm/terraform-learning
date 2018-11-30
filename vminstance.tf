# Vcenter details
data "vsphere_datacenter" "dc" {
  name = "DC_TEST"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "cluster1/Resources"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  #name          = "Templates/RHEL7.3"
  name          = "Templates/RHEL7_Template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder            = "TEST"

  num_cpus = 1
  memory   = 1024
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"


  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }


  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "terraform-test1"
        domain    = "example.com"
      }

      network_interface {
        ipv4_address = "172.16.130.200"
        ipv4_netmask = 24
      }

      ipv4_gateway = "172.16.130.2"

    }
  }
  provisioner "file" {
    source      = "/root/Terraform/Codez/post_installation.sh"
    destination = "/root/post_installation.sh"
  
   connection {
     type     = "ssh"
     user     = "root"
     password = "${var.root_password}" 
   }    
  }

   provisioner "remote-exec" {
     connection {
       type     = "ssh"
       user     = "root"
       password = "${var.root_password}"
     }
     
   inline = [
     "chmod +x /root/post_installation.sh",
     "/root/post_installation.sh",
    ]
   }

}
