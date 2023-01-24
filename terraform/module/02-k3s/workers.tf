data "scaleway_instance_server" "k3s_worker" {
  for_each = var.az.k3s_worker
  name = "${data.scaleway_account_project.by_project_id.name}-${var.zone}-${each.key}"
}

resource "scaleway_instance_server" "k3s_worker" {
  for_each    = var.az.k3s_worker
  name        = "${data.scaleway_account_project.by_project_id.name}-${var.zone}-${each.key}"
  image       = data.scaleway_instance_image.k3s.image_id
  type        = "DEV1-M"
  enable_ipv6 = true
  state       = var.instance_state
  root_volume {
    volume_type = "b_ssd"
    size_in_gb  = 10
  }

  private_network {
    pn_id = var.private_network_id
  }

  additional_volume_ids = data.scaleway_instance_server.k3s_worker[each.key].additional_volume_ids
}

locals {
  k3s_worker_content = { for k, v in var.az.k3s_worker : k => templatefile("${path.module}/templates/k3s.sh", {
    SQL_HOST        = var.db.private_ip
    SQL_PORT        = var.db.private_port
    SQL_DB          = var.db.name
    SQL_USER        = var.db.user
    SQL_PASS        = var.db.password
    NODE_IP         = v.private_ip
    NODE_ID         = k
    NODE_LABELS     = ""
    NODE_TAINTS     = ""
    K3S_TOKEN       = random_password.k3s_token.result
    K3S_AGENT_TOKEN = random_password.k3s_agent_token.result
    TLS_SAN         = ""
    SERVER_URL      = "https://master.k3s.default.pewty.xyz:6443"
  }) }
  net_worker_content = { for k, v in var.az.k3s_worker : k => templatefile("${path.module}/templates/net.sh", {
    PRIVATE_IP         = v.private_ip
    PRIVATE_NETMASK    = var.az.private_mask
    PRIVATE_IP_V6      = v.private_ip_v6
    PRIVATE_NETMASK_V6 = var.az.private_mask_v6
    MASTER_PRIVATE_IPS = [for node in var.az.k3s_master : node.private_ip]
  }) }
}

resource "aws_s3_object" "net_worker" {
  for_each = var.az.k3s_worker
  bucket   = "pewty-instance-config"
  key      = "${scaleway_instance_server.k3s_worker[each.key].name}/net.sh"
  content  = local.net_worker_content[each.key]
  etag     = md5(local.net_worker_content[each.key])
  tags = {
    update = "yes"
  }
}

resource "aws_s3_object" "k3s_worker" {
  for_each = var.az.k3s_worker
  bucket   = "pewty-instance-config"
  key      = "${scaleway_instance_server.k3s_worker[each.key].name}/k3s.sh"
  content  = local.k3s_worker_content[each.key]
  etag     = md5(local.k3s_worker_content[each.key])

  tags = {
    update = "yes"
  }
}
