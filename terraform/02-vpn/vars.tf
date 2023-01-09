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
  type = string
  description = "Image for scw netmaker instance"
} 

data "scaleway_account_project" "by_project_id" {
  project_id = var.project
}
