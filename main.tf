
data "template_file" "userdata_default" {
  template = file("userdata.tpl")
  vars = {
    HOSTNAME = var.guestHostname
  }
}

provider "esxi" {
  esxi_hostname      = var.esxiHostname
  esxi_hostport      = var.esxiSSHPort
  esxi_hostssl       = var.esxiSSLPort
  esxi_username      = var.esxiUsername
  esxi_password      = var.esxiPassword
}

resource "esxi_guest" "vmguest" {
  guest_name         = var.guestHostname
  disk_store         = var.dataStore
  clone_from_vm      = var.templateVM
  memsize = 2048
  numvcpus = 2
  power = "on"

  network_interfaces {
    virtual_network = var.virtualNetwork
  }

  guestinfo = {
    "userdata.encoding" = "gzip+base64"
    "userdata"          = base64gzip(data.template_file.userdata_default.rendered)
  }
}

