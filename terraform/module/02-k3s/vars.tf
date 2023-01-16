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
  type = object({
    public_ip    = string
    public_port  = string
    private_ip   = string
    private_port = string
    name         = string
    user         = string
    password     = string
  })
}

variable "pool_def" {
  type = object({
    net     = string
    mask    = string
    az_name = string
  })
}

variable "instance_state" {
  type    = string
  default = "started"
}

variable "az" {
  type = object({
    wg_net       = string
    wg_mask      = string
    private_net  = string
    private_mask = string
    db = map(object({
      private_ip = string
    }))
    k3s_master = map(object({
      private_ip = string
    }))
    k3s_worker = map(object({
      private_ip = string
    }))
  })
  description = "description"
}

data "scaleway_account_project" "by_project_id" {
  project_id = var.project
}

data "scaleway_instance_image" "k3s" {
  name = var.image
}
