
resource "scaleway_rdb_database" "k3s" {
  instance_id = scaleway_rdb_instance.pewty["db-01"].id
  name        = "k3s"
}

resource "random_password" "k3s_password" {
  length           = 30
  override_special = "*?!-_=+:"
}

resource "scaleway_rdb_user" "k3s_admin" {
  instance_id = scaleway_rdb_instance.pewty["db-01"].id
  name        = "k3s"
  password    = random_password.k3s_password.result
  is_admin    = true
}

resource "scaleway_rdb_privilege" "k3s" {
  instance_id   = scaleway_rdb_instance.pewty["db-01"].id
  user_name     = "k3s"
  database_name = "k3s"
  permission    = "all"

  depends_on = [scaleway_rdb_user.k3s_admin, scaleway_rdb_database.k3s]
}
