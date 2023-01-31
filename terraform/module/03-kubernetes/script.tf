resource "random_password" "gitea" {
  length  = 30
  upper   = true
  lower   = true
  numeric = true
  special = true
}

resource "random_password" "authentik" {
  length  = 30
  upper   = true
  lower   = true
  numeric = true
  special = true
}

resource random_password grafana_oauth_client_id {
  length  = 40
}

resource random_password grafana_oauth_client_secret {
  length  = 128
}

locals {
  kubernetes_master_content = templatefile("${path.module}/templates/kubernetes.sh", {
    SECRETS = templatefile("${path.module}/templates/secrets.yaml", {
      SCW_ACCESS_KEY         = base64encode(var.scw_access_key)
      SCW_SECRET_KEY         = base64encode(var.scw_secret_key)
      SCW_DEFAULT_PROJECT_ID = base64encode(var.project)
      SCW_DEFAULT_ZONE       = base64encode(var.zone)
      GITEA_USERNAME         = base64encode(var.default_user.username)
      GITEA_PASSWORD         = base64encode(random_password.gitea.result)
      GITEA_EMAIL            = base64encode(var.default_user.email)
    })
    ARGOCD = templatefile("${path.module}/templates/argocd.values.yaml", {
      DOMAIN = "${var.applications.dashboard.domain}.${data.scaleway_account_project.by_project_id.name}.${var.applications.dashboard.zone}"
    })
    VM_STACK = templatefile("${path.module}/templates/vm-stack.values.yaml", {
      ALERTMANAGER_DOMAIN = "${var.applications.alertmanager.domain}.${data.scaleway_account_project.by_project_id.name}.${var.applications.alertmanager.zone}"
      GRAFANA_DOMAIN      = "${var.applications.grafana.domain}.${data.scaleway_account_project.by_project_id.name}.${var.applications.grafana.zone}"
      GRAFANA_OAUTH_APP = "authentik"
      GRAFANA_OAUTH_GF_APP = "grafana"
      GRAFANA_OAUTH_CLIENT_ID = random_password.grafana_oauth_client_id.result
      GRAFANA_OAUTH_CLIENT_SECRET = random_password.grafana_oauth_client_secret.result
      GRAFANA_OAUTH_DOMAIN = "${var.applications.authentik.domain}.${data.scaleway_account_project.by_project_id.name}.${var.applications.authentik.zone}"
    })
    DASHBOARD = templatefile("${path.module}/templates/dashboard.values.yaml", {
      DOMAIN = "${var.applications.dashboard.domain}.${data.scaleway_account_project.by_project_id.name}.${var.applications.dashboard.zone}"
    })
    GITEA = templatefile("${path.module}/templates/gitea.values.yaml", {
      GITEA_IP       = var.db.private_ip
      GITEA_PORT     = var.db.private_port
      GITEA_NAME     = var.db.gitea.name
      GITEA_USER     = var.db.gitea.user
      GITEA_PASSWORD = var.db.gitea.password
      DOMAIN         = "${var.applications.gitea.domain}.${data.scaleway_account_project.by_project_id.name}.${var.applications.gitea.zone}"
    })
    AUTHENTIK = templatefile("${path.module}/templates/authentik.values.yaml", {
      AUTHENTIK_IP       = var.db.private_ip
      AUTHENTIK_PORT     = var.db.private_port
      AUTHENTIK_NAME     = var.db.authentik.name
      AUTHENTIK_USER     = var.db.authentik.user
      AUTHENTIK_PASSWORD = var.db.authentik.password
      DOMAIN             = "${var.applications.authentik.domain}.${data.scaleway_account_project.by_project_id.name}.${var.applications.authentik.zone}"
      SECRET_KEY         = random_password.authentik.result
    })
    UPTIME_KUMA = templatefile("${path.module}/templates/uptime-kuma.values.yaml", {
      DOMAIN = "${var.applications.uptimekuma.domain}.${data.scaleway_account_project.by_project_id.name}.${var.applications.uptimekuma.zone}"
    })
    NTFY = templatefile("${path.module}/templates/ntfy.yaml", {
      DOMAIN = "${var.applications.ntfy.domain}.${data.scaleway_account_project.by_project_id.name}.${var.applications.ntfy.zone}"
    })
    ECHOIP = templatefile("${path.module}/templates/echoip.yaml", {
      DOMAIN = "${var.applications.echoip.domain}.${data.scaleway_account_project.by_project_id.name}.${var.applications.echoip.zone}"
    })
    TRAEFIK = file("${path.module}/templates/traefik.yaml")
  })
}

# data "aws_s3_object" "kubernetes_master" {
#   bucket   = "pewty-instance-config"
#   key      = "${var.k3s_master_name}/kubernetes.sh"
# }

resource "aws_s3_object" "kubernetes_master" {
  bucket  = "pewty-instance-config"
  key     = "${var.k3s_master_name}/kubernetes.sh"
  content = local.kubernetes_master_content
  etag    = md5(local.kubernetes_master_content)
  tags = {
    update = "yes" #( md5(local.kubernetes_master_content) == data.aws_s3_object.kubernetes_master.etag ? "no" : "yes")
  }
}
