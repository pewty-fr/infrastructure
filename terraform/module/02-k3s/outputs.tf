output "k3s_master" {
  value = scaleway_instance_server.k3s_master
}

output "k3s_worker" {
  value = scaleway_instance_server.k3s_worker
}
