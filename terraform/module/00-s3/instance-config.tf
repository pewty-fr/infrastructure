resource "scaleway_object_bucket" "instance_config" {
  name = "pewty-instance-config"
  acl  = "private"
}
