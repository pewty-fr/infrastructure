terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
  }
  required_version = ">= 1.3"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
