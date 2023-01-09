
resource "scaleway_rdb_database" "vpn" {
  instance_id = scaleway_rdb_instance.pewty["db-01"].id
  name        = "vpn"
}

resource "random_password" "vpn_password" {
  length  = 30
  override_special = "*?@!-_=+:" 
}

resource "scaleway_rdb_user" "vpn_admin" {
  instance_id = scaleway_rdb_instance.pewty["db-01"].id
  name        = "vpn"
  password    = random_password.vpn_password.result
  is_admin    = true
}

resource "scaleway_rdb_privilege" "vpn" {
  instance_id   = scaleway_rdb_instance.pewty["db-01"].id
  user_name     = "vpn"
  database_name = "vpn"
  permission    = "all"

  depends_on = [scaleway_rdb_user.vpn_admin, scaleway_rdb_database.vpn]
}
