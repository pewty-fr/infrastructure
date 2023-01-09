
packer {
  required_version = ">=1.8.5"
  required_plugins {
    scaleway = {
      version = ">= 1.0.5"
      source  = "github.com/scaleway/scaleway"
    }
  }
}

variable "name" {
  type    = string
  default = "netmaker"
}

variable "project_id" {
  type    = string
  default = "a26a2ce4-2fbf-4cde-8e06-3d2dd3d962d7"
}

source "scaleway" "pewty" {
  project_id           = var.project_id
  image                = "ubuntu_jammy"
  zone                 = "fr-par-1"
  commercial_type      = "DEV1-S"
  ssh_username         = "root"
  ssh_private_key_file = "~/.ssh/id_rsa"
  image_name           = "ubuntu-${var.name}-pewty-${formatdate("DD-MM-YYYY-hh-mm", timestamp())}"
  snapshot_name        = "ubuntu-${var.name}-pewty-snapshot-${formatdate("DD-MM-YYYY-hh-mm", timestamp())}"
}

build {
  sources = ["source.scaleway.pewty"]
  provisioner "shell" {
    script = "bootstrap.sh"
  }
  provisioner "file" {
    source      = "files/"
    destination = "/tmp/"
  }
}
