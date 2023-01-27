output pool {
  value       = var.pool
}

output k3s_masters {
    value = module.k3s_AZ_A.k3s_masters
}

output k3s_workers {
    value = module.k3s_AZ_A.k3s_workers
}

output db {
    sensitive = true
    value = module.db_AZ_A.db
}
