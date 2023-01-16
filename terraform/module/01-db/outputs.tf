output "db_k3s" {
  sensitive   = true
  description = "description"
  value = {
    public_ip    = scaleway_rdb_instance.pewty["db-01"].load_balancer[0].ip
    public_port  = scaleway_rdb_instance.pewty["db-01"].load_balancer[0].port
    private_ip   = scaleway_rdb_instance.pewty["db-01"].private_network[0].ip
    private_port = scaleway_rdb_instance.pewty["db-01"].private_network[0].port
    name         = scaleway_rdb_database.k3s.name
    user         = scaleway_rdb_user.k3s_admin.name
    password     = scaleway_rdb_user.k3s_admin.password
  }
}
