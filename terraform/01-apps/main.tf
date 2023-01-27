data terraform_remote_state infra {
  backend = "s3"

  config = {
    bucket                      = "pewty-tfstate"
    key                         = "infrastructure/terraform/00-infra.tfstate"
    region                      = "fr-par"
    endpoint                    = "https://s3.fr-par.scw.cloud"
    skip_credentials_validation = true
    skip_region_validation      = true
  }
}

module "wireguard_AZ_A" {
  source  = "../module/03-wireguard"
  region  = var.region
  project = var.project
  zone    = var.zone
  az      = data.terraform_remote_state.infra.outputs.pool.AZs["AZ_A"] # static data
  scw_instance = { # dynamic data
    k3s_master = data.terraform_remote_state.infra.outputs.k3s_masters
    k3s_worker = data.terraform_remote_state.infra.outputs.k3s_workers
  }
  external_device = var.external_device
}


module "haproxy" {
  source          = "../module/03-haproxy"
  region          = var.region
  project         = var.project
  zone            = var.zone
  applications = var.applications
  default_user    = var.default_user
  az      = data.terraform_remote_state.infra.outputs.pool.AZs["AZ_A"] # static data
  scw_instance = { # dynamic data
    k3s_master = data.terraform_remote_state.infra.outputs.k3s_masters
    k3s_worker = data.terraform_remote_state.infra.outputs.k3s_workers
  }
}

module "kubernetes" {
  source          = "../module/03-kubernetes"
  region          = var.region
  project         = var.project
  zone            = var.zone
  scw_access_key  = var.scw_access_key
  scw_secret_key  = var.scw_secret_key
  az      = data.terraform_remote_state.infra.outputs.pool.AZs["AZ_A"] # static data
  scw_instance = { # dynamic data
    k3s_master = data.terraform_remote_state.infra.outputs.k3s_masters
    k3s_worker = data.terraform_remote_state.infra.outputs.k3s_workers
  }
  k3s_master_name = data.terraform_remote_state.infra.outputs.k3s_masters["k3s-master-01"].name
  default_user    = var.default_user
  db = data.terraform_remote_state.infra.outputs.db
  applications = var.applications
}
