

resource "scaleway_instance_ip" "ip" {
  for_each = var.az.k3s_master
}

resource "scaleway_instance_server" "k3s_master" {
  for_each    = var.az.k3s_master
  name        = "${data.scaleway_account_project.by_project_id.name}-${var.zone}-${each.key}"
  image       = data.scaleway_instance_image.k3s.image_id
  type        = "DEV1-S"
  enable_ipv6 = true
  ip_id       = scaleway_instance_ip.ip[each.key].id
  state       = var.instance_state
  root_volume {
    volume_type = "b_ssd"
    size_in_gb  = 10
  }

  private_network {
    pn_id = var.private_network_id
  }
}

resource "aws_s3_object" "net_master" {
  for_each = var.az.k3s_master
  bucket   = "pewty-instance-config"
  key = "${scaleway_instance_server.k3s_master[each.key].name}/net.sh"
  content = templatefile("${path.module}/templates/net.sh", {
    PRIVATE_IP      = each.value.private_ip
    PRIVATE_NETMASK = var.az.private_mask
  })

  tags = {
    update = "yes"
  }
}

resource "aws_s3_object" "k3s_master" {
  for_each = var.az.k3s_master
  bucket   = "pewty-instance-config"
  key      = "${scaleway_instance_server.k3s_master[each.key].name}/k3s.sh"
  content = templatefile("${path.module}/templates/k3s.sh", {
    SQL_HOST        = var.db.private_ip
    SQL_PORT        = var.db.private_port
    SQL_DB          = var.db.name
    SQL_USER        = var.db.user
    SQL_PASS        = var.db.password
    NODE_IP         = each.value.private_ip
    NODE_ID         = each.key
    NODE_LABELS     = ""
    NODE_TAINTS     = ""
    K3S_TOKEN       = random_password.k3s_token.result
    K3S_AGENT_TOKEN = random_password.k3s_agent_token.result
    TLS_SAN         = "master.k3s.default.pewty.xyz"
    SERVER_URL      = ""
  })
  tags = {
    update = "yes"
  }
}
