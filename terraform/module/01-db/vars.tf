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
  description = "Scaleway project ID"
}

variable "private_network_id" {
  type        = string
  description = "ID of the private network"
}

variable "pool_def" {
  type = object({
    net     = string
    mask    = string
    az_name = string
  })
}

variable "az" {
  type = object({
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
