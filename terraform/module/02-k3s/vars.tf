variable "region" {
  type        = string
  description = "Scaleway region"
}

variable "zone" {
  type        = string
  description = "Scaleway zone"
}

variable "project" {
  type        = string
  description = "Scaleway project"
}

variable "image" {
  type        = string
  description = "Image for scw k3s instance"
}

variable "private_network_id" {
  type        = string
  description = "ID of the private network"
}

variable "db" {
  description = "description"
  type = any
}


variable "instance_state" {
  type    = string
  default = "started"
}

variable "az" {
  type = any
  description = "description"
}

data "scaleway_account_project" "by_project_id" {
  project_id = var.project
}

data "scaleway_instance_image" "k3s" {
  name = var.image
}

