output "private_network_id" {
  value       = scaleway_vpc_private_network.default.id
  description = "ID of the private network"
}
