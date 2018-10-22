variable "vsphere_server" {
    description = "vsphere server for the environment - EXAMPLE: vcenter01.hosted.local"
    default = "vcenter.example.com"
}

variable "vsphere_user" {
    description = "vsphere server for the environment - EXAMPLE: vsphereuser"
    default = "administrator@vsphere.local"
}

variable "vsphere_password" {
    description = "vsphere server password for the environment"
    default = "@Admin1234"
}

variable "virtual_machine_dns_servers" {
  type    = "list"
  default = ["172.16.130.133", "172.16.130.2"]
}

