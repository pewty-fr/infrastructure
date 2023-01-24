resource "random_password" "gitea" {
  length  = 30
  upper   = true
  lower   = true
  numeric = true
  special = true
}

locals {
  k3s_master_content = templatefile("${path.module}/templates/kubernetes-base.sh", {
    SECRETS = templatefile("${path.module}/templates/secrets.yaml", {
      SCW_ACCESS_KEY         = base64encode(var.scw_access_key)
      SCW_SECRET_KEY         = base64encode(var.scw_secret_key)
      SCW_DEFAULT_PROJECT_ID = base64encode(var.project)
      SCW_DEFAULT_ZONE       = base64encode(var.zone)
      GITEA_USERNAME         = base64encode(var.default_user.username)
      GITEA_PASSWORD         = base64encode(random_password.gitea.result)
      GITEA_EMAIL            = base64encode(var.default_user.email)
    })
  })
}

resource "aws_s3_object" "k3s_master" {
  bucket  = "pewty-instance-config"
  key     = "${var.k3s_master_name}/kubernetes-base.sh"
  content = local.k3s_master_content
  etag    = md5(local.k3s_master_content)
  tags = {
    update = "yes"
  }
}
