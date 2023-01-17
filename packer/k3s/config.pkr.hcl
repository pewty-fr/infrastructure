
packer {
  required_plugins {
    scaleway = {
      version = ">= 1.0.5"
      source  = "github.com/scaleway/scaleway"
    }
  }
}

variable "name" {
  type = string
  default = "k3s"
}

variable "project_id" {
  type = string
  default = "a26a2ce4-2fbf-4cde-8e06-3d2dd3d962d7"
}

variable "scw_access_key" {
  type = string
  default = env("SCW_ACCESS_KEY")
}

variable "scw_secret_key" {
  type = string
  default = env("SCW_SECRET_KEY")
}

source "scaleway" "pewty" {
  project_id = var.project_id
  image = "ubuntu_jammy"
  zone = "fr-par-1"
  commercial_type = "DEV1-S"
  ssh_username = "root"
  ssh_private_key_file = "~/.ssh/id_rsa"
  image_name = "ubuntu-${var.name}-pewty-${formatdate("DD-MM-YYYY-hh-mm", timestamp())}"
  snapshot_name = "ubuntu-${var.name}-pewty-snapshot-${formatdate("DD-MM-YYYY-hh-mm", timestamp())}"
  image_size_in_gb = 10
}

build {
  sources = ["source.scaleway.pewty"]
  provisioner "file" {
    source = "files/"
    destination = "/tmp/"
  }
  provisioner "shell" {
    script = "bootstrap.sh"
    env = {
      SCW_ACCESS_KEY = var.scw_access_key
      SCW_SECRET_KEY = var.scw_secret_key
    }
  }
}
