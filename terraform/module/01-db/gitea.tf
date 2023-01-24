
resource "scaleway_rdb_database" "gitea" {
  instance_id = scaleway_rdb_instance.pewty["db-01"].id
  name        = "gitea"
}

resource "random_password" "gitea_password" {
  length           = 30
  override_special = "*?@!-_=+:"
}

resource "scaleway_rdb_user" "gitea_admin" {
  instance_id = scaleway_rdb_instance.pewty["db-01"].id
  name        = "gitea"
  password    = random_password.gitea_password.result
  is_admin    = true
}

resource "scaleway_rdb_privilege" "gitea" {
  instance_id   = scaleway_rdb_instance.pewty["db-01"].id
  user_name     = "gitea"
  database_name = "gitea"
  permission    = "all"

  depends_on = [scaleway_rdb_user.gitea_admin, scaleway_rdb_database.gitea]
}
