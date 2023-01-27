module "network" {
  source  = "../module/00-network"
  region  = var.region
  project = var.project
  zone    = var.zone
}

module "s3" {
  source  = "../module/00-s3"
  region  = var.region
  project = var.project
  zone    = var.zone
}

module "db_AZ_A" {
  source             = "../module/01-db"
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
  source             = "../module/02-k3s"
  region             = var.region
  project            = var.project
  zone               = var.zone
  image              = var.image
  db                 = module.db_AZ_A.db
  private_network_id = module.network.private_network_id
  az                 = var.pool.AZs["AZ_A"]
  instance_state = var.instance_state
}
