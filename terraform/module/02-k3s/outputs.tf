output "k3s_masters" {
  value = scaleway_instance_server.k3s_master
}

output "k3s_workers" {
  value = scaleway_instance_server.k3s_worker
}
