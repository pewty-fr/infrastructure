resource "scaleway_rdb_instance" "pewty" {
  for_each                  = var.az.db
  name                      = "pewty-${data.scaleway_account_project.by_project_id.name}-${each.key}"
  node_type                 = "db-dev-s"
  engine                    = "PostgreSQL-14"
  is_ha_cluster             = false
  backup_same_region        = false
  backup_schedule_frequency = 24
  backup_schedule_retention = 7
  disable_backup            = false
  init_settings             = {}
  settings = {
    effective_cache_size            = "1300"
    maintenance_work_mem            = "150"
    max_connections                 = "100"
    max_parallel_workers            = "0"
    max_parallel_workers_per_gather = "0"
    work_mem                        = "4"
  }
  volume_size_in_gb = 10
  volume_type       = "bssd"
  timeouts {}
  private_network {
    ip_net = "${each.value.private_ip}/${var.az.private_mask}"
    pn_id  = var.private_network_id
  }
}
