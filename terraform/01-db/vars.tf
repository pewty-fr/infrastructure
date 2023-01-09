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

data scaleway_account_project "by_project_id" {
  project_id = var.project
}