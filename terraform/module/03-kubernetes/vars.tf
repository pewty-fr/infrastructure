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

variable "scw_access_key" {
  sensitive = true
  type      = string
}

variable "scw_secret_key" {
  sensitive = true
  type      = string
}

variable "k3s_master_name" {
  type        = string
  description = "description"
}


variable "default_user" {
  type = object({
    username = string
    email    = string
  })
}

variable "az" {
  type = any
  description = "description"
}

variable db {
  type = any
}

variable "applications" {
  type = any
}

data "scaleway_account_project" "by_project_id" {
  project_id = var.project
}

variable "scw_instance" {
  type = object({
    k3s_master = map(any)
    k3s_worker = map(any)
  })
}
