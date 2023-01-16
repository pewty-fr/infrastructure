resource "scaleway_vpc_private_network" "default" {
  name = "default"
  tags = ["k3s", "netmaker"]
}