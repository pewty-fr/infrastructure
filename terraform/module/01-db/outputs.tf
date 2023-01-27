output "db" {
  sensitive   = true
  description = "description"
  value = {
    public_ip    = scaleway_rdb_instance.pewty["db-01"].load_balancer[0].ip
    public_port  = scaleway_rdb_instance.pewty["db-01"].load_balancer[0].port
    private_ip   = scaleway_rdb_instance.pewty["db-01"].private_network[0].ip
    private_port = scaleway_rdb_instance.pewty["db-01"].private_network[0].port
    k3s = {
      name         = scaleway_rdb_database.k3s.name
      user         = scaleway_rdb_user.k3s_admin.name
      password     = scaleway_rdb_user.k3s_admin.password
    }
    gitea = {
    name         = scaleway_rdb_database.gitea.name
    user         = scaleway_rdb_user.gitea_admin.name
    password     = scaleway_rdb_user.gitea_admin.password

    }
    authentik = {
    name         = scaleway_rdb_database.authentik.name
    user         = scaleway_rdb_user.authentik_admin.name
    password     = scaleway_rdb_user.authentik_admin.password
    }
  }
}
