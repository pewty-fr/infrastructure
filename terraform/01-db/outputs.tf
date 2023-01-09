output "db_k3s" {
  sensitive   = true
  description = "description"
  value = {
    host     = scaleway_rdb_instance.pewty["db-01"].load_balancer[0].ip
    port     = scaleway_rdb_instance.pewty["db-01"].load_balancer[0].port
    name     = scaleway_rdb_database.k3s.name
    user     = scaleway_rdb_user.k3s_admin.name
    password = scaleway_rdb_user.k3s_admin.password
  }
}

output "db_vpn" {
  sensitive   = true
  description = "description"
  value = {
    host     = scaleway_rdb_instance.pewty["db-01"].load_balancer[0].ip
    port     = scaleway_rdb_instance.pewty["db-01"].load_balancer[0].port
    name     = scaleway_rdb_database.vpn.name
    user     = scaleway_rdb_user.vpn_admin.name
    password = scaleway_rdb_user.vpn_admin.password
  }
}