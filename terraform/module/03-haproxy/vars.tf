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

variable "az" {
  type = any
  description = "description"
}

data "scaleway_account_project" "by_project_id" {
  project_id = var.project
}

variable "applications" {
  type = any
}

variable "scw_instance" {
  type = object({
    k3s_master = map(any)
    k3s_worker = map(any)
  })
}

variable "default_user" {
  type = object({
    username = string
    email    = string
  })
}
