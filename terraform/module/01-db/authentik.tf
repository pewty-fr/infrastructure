
resource "scaleway_rdb_database" "authentik" {
  instance_id = scaleway_rdb_instance.pewty["db-01"].id
  name        = "authentik"
}

resource "random_password" "authentik_password" {
  length           = 30
  override_special = "*?@!-_=+:"
}

resource "scaleway_rdb_user" "authentik_admin" {
  instance_id = scaleway_rdb_instance.pewty["db-01"].id
  name        = "authentik"
  password    = random_password.authentik_password.result
  is_admin    = true
}

resource "scaleway_rdb_privilege" "authentik" {
  instance_id   = scaleway_rdb_instance.pewty["db-01"].id
  user_name     = "authentik"
  database_name = "authentik"
  permission    = "all"

  depends_on = [scaleway_rdb_user.authentik_admin, scaleway_rdb_database.authentik]
}
