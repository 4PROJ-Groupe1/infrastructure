terraform {
  required_version = ">= 0.13"
  required_providers {
    esxi = {
      source = "registry.terraform.io/josenk/esxi"
      # https://github.com/josenk/terraform-provider-esxi

    }
  }
}

provider "esxi" {
  esxi_hostname      = "10.0.30.10"
  esxi_hostport      = "22"
  esxi_hostssl       = "443"
  esxi_username      = "root"
  esxi_password      = var.esxi_password
}

resource "esxi_guest" "createVirtualMachine" {
  count = 2
  guest_name = "4PROJ-UBU18-KUBE${count.index + 1}"
  disk_store = "datastore"
  guestos    = "debian9-64"

  boot_disk_type = "thin"
  boot_disk_size = "16"

  memsize            = "2048"
  numvcpus           = "1"
  power              = "on"
  clone_from_vm      = "TEMPLATE-UBUNTU18"

  network_interfaces {
    virtual_network = "VLAN-PREPROD"
    nic_type        = "vmxnet3"
  }
}
