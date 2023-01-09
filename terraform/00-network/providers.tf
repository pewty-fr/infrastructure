terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.8.0"
    }
  }
  required_version = ">= 1.3"
}

provider "scaleway" {
  region          = var.region
  zone            = var.zone
  project_id      = var.project
  organization_id = "a26a2ce4-2fbf-4cde-8e06-3d2dd3d962d7"
}