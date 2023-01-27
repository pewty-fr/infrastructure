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

variable "external_device" {
  type = map(object({
    wg_ip = string
  }))
  default     = {}
  description = "description"
}

variable "az" {
  type = any
  description = "description"
}

variable "scw_instance" {
  type = object({
    k3s_master = map(any)
    k3s_worker = map(any)
  })
}

data "scaleway_account_project" "by_project_id" {
  project_id = var.project
}
