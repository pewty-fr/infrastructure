resource "random_password" "authentik_secret_key" {
  length  = 30
  upper   = true
  lower   = true
  numeric = true
  special = true
}

locals {
  content = templatefile("${path.module}/templates/00-kubernetes-apps.sh", {
    VM_STACK = templatefile("${path.module}/templates/vm-stack.values.yaml", {
      ALERTMANAGER_DOMAIN = "${var.applications["alertmanager"].domain}.${data.scaleway_account_project.by_project_id.name}.pewty.xyz"
      GRAFANA_DOMAIN      = "${var.applications["grafana"].domain}.${data.scaleway_account_project.by_project_id.name}.pewty.xyz"
    })
    DASHBOARD = templatefile("${path.module}/templates/dashboard.values.yaml", {
      DOMAIN = "${var.applications["dashboard"].domain}.${data.scaleway_account_project.by_project_id.name}.pewty.xyz"
    })
    GITEA = templatefile("${path.module}/templates/gitea.values.yaml", {
      GITEA_IP       = var.db["gitea"].private_ip
      GITEA_PORT     = var.db["gitea"].private_port
      GITEA_NAME     = var.db["gitea"].name
      GITEA_USER     = var.db["gitea"].user
      GITEA_PASSWORD = var.db["gitea"].password
      DOMAIN         = "${var.applications["gitea"].domain}.${data.scaleway_account_project.by_project_id.name}.pewty.xyz"
    })
    AUTHENTIK = templatefile("${path.module}/templates/authentik.values.yaml", {
      AUTHENTIK_IP       = var.db["authentik"].private_ip
      AUTHENTIK_PORT     = var.db["authentik"].private_port
      AUTHENTIK_NAME     = var.db["authentik"].name
      AUTHENTIK_USER     = var.db["authentik"].user
      AUTHENTIK_PASSWORD = var.db["authentik"].password
      DOMAIN             = "${var.applications["authentik"].domain}.${data.scaleway_account_project.by_project_id.name}.pewty.xyz"
      SECRET_KEY         = random_password.authentik_secret_key.result
    })
  })
}

resource "aws_s3_object" "k3s_master" {
  bucket  = "pewty-instance-config"
  key     = "${var.k3s_master_name}/kubernetes-apps.sh"
  content = local.content
  etag    = md5(local.content)
  tags = {
    update = "yes"
  }
}
