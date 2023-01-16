terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.8.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    wireguard = {
      source  = "OJFord/wireguard"
      version = "0.2.1+1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.3.0"
    }
  }
  required_version = ">= 1.3"
}

provider "scaleway" {
  region     = var.region
  zone       = var.zone
  project_id = var.project
}

# Configure the AWS Provider
provider "aws" {
  region = "fr-par"
  endpoints {
    s3 = "https://s3.fr-par.scw.cloud"
  }
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_region_validation      = true
}

provider "wireguard" {}

provider "local" {}

