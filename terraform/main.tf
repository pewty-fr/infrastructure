data "scaleway_account_project" "by_project_id" {
  project_id = var.project
}

module "network" {
  source  = "./module/00-network"
  region  = var.region
  project = var.project
  zone    = var.zone
}

module "s3" {
  source  = "./module/00-s3"
  region  = var.region
  project = var.project
  zone    = var.zone
}

module "db_AZ_A" {
  source             = "./module/01-db"
  region             = var.region
  project            = var.project
  zone               = var.zone
  private_network_id = module.network.private_network_id
  az                 = var.pool.AZs["AZ_A"]
  pool_def = {
    net     = var.pool.net
    mask    = var.pool.mask
    az_name = "AZ_A"
  }
}

module "k3s_AZ_A" {
  source             = "./module/02-k3s"
  region             = var.region
  project            = var.project
  zone               = var.zone
  image              = var.image
  db                 = module.db_AZ_A.db_k3s
  private_network_id = module.network.private_network_id
  az                 = var.pool.AZs["AZ_A"]
  pool_def = {
    net     = var.pool.net
    mask    = var.pool.mask
    az_name = "AZ_A"
  }
  instance_state = var.instance_state
}

module "wireguard_AZ_A" {
  source  = "./module/03-wireguard"
  region  = var.region
  project = var.project
  zone    = var.zone
  az      = var.pool.AZs["AZ_A"] # static data
  pool_def = {
    net     = var.pool.net
    mask    = var.pool.mask
    az_name = "AZ_A"
  }
  wg_server = { # dynamic data
    k3s_master = module.k3s_AZ_A.k3s_master
    k3s_worker = module.k3s_AZ_A.k3s_worker
  }
  external_device = var.external_device
}

module "kubernetes_base" {
  source          = "./module/04-kubernetes-base"
  region          = var.region
  project         = var.project
  zone            = var.zone
  scw_access_key  = var.scw_access_key
  scw_secret_key  = var.scw_secret_key
  k3s_master_name = module.k3s_AZ_A.k3s_master["k3s-master-01"].name
}

module "kubernetes_apps" {
  source          = "./module/05-kubernetes-apps"
  region          = var.region
  project         = var.project
  zone            = var.zone
  k3s_master_name = module.k3s_AZ_A.k3s_master["k3s-master-01"].name
}
