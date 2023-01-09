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

variable "master_image" {
  type = string
  description = "Image for scw k3s master instance"
} 

variable "worker_image" {
  type = string
  description = "Image for scw k3s worker instance"
} 

data "scaleway_account_project" "by_project_id" {
  project_id = var.project
}
