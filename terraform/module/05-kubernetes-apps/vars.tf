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

variable "k3s_master_name" {
  type        = string
  description = "description"
}

variable "db" {
  type = map(object({
    public_ip    = string
    public_port  = string
    private_ip   = string
    private_port = string
    name         = string
    user         = string
    password     = string
  }))
}

variable "applications" {
  type = map(object({
    domain    = string
    is_public = bool
  }))
}

data "scaleway_account_project" "by_project_id" {
  project_id = var.project
}
