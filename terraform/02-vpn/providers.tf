terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.8.0"
    }
    random = {
      version = "3.4.3"
    }
    ovh = {
      source  = "ovh/ovh"
      version = "0.26.0"
    }
  }
  required_version = ">= 1.3"
}

provider "scaleway" {
  region          = "fr-par"
  zone            = "fr-par-1"
  project_id      = "a26a2ce4-2fbf-4cde-8e06-3d2dd3d962d7"
  organization_id = "a26a2ce4-2fbf-4cde-8e06-3d2dd3d962d7"
}

provider "ovh" {
  endpoint = "ovh-eu"
}
