

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


locals {
  k3s_master_content = { for k, v in var.az.k3s_master : k => templatefile("${path.module}/templates/k3s.sh", {
    SQL_HOST        = var.db.private_ip
    SQL_PORT        = var.db.private_port
    SQL_DB          = var.db.k3s.name
    SQL_USER        = var.db.k3s.user
    SQL_PASS        = var.db.k3s.password
    NODE_IP         = v.private_ip
    NODE_ID         = k
    NODE_LABELS     = ""
    NODE_TAINTS     = "node-role.kubernetes.io/master:NoSchedule"
    K3S_TOKEN       = random_password.k3s_token.result
    K3S_AGENT_TOKEN = random_password.k3s_agent_token.result
    TLS_SAN         = "master.k3s.default.pewty.xyz"
    SERVER_URL      = ""
  }) }

  net_master_content = { for k, v in var.az.k3s_master : k => templatefile("${path.module}/templates/net.sh", {
    PRIVATE_IP         = v.private_ip
    PRIVATE_NETMASK    = var.az.private_mask
    PRIVATE_IP_V6      = v.private_ip_v6
    PRIVATE_NETMASK_V6 = var.az.private_mask_v6
    MASTER_PRIVATE_IPS = []
  }) }
}

resource "aws_s3_object" "net_master" {
  for_each = var.az.k3s_master
  bucket   = "pewty-instance-config"
  key      = "${scaleway_instance_server.k3s_master[each.key].name}/net.sh"
  content  = local.net_master_content[each.key]
  etag     = md5(local.net_master_content[each.key])

  tags = {
    update = "yes"
  }
}

resource "aws_s3_object" "k3s_master" {
  for_each = var.az.k3s_master
  bucket   = "pewty-instance-config"
  key      = "${scaleway_instance_server.k3s_master[each.key].name}/k3s.sh"
  content  = local.k3s_master_content[each.key]
  etag     = md5(local.k3s_master_content[each.key])
  tags = {
    update = "yes"
  }
}

resource "scaleway_instance_security_group" "k3s_master" {
  name = "k3s_master"
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action = "accept"
    port   = 22
    ip_range     = "0.0.0.0/0"
  }

  inbound_rule {
    action = "accept"
    port   = 80
    ip_range     = "0.0.0.0/0"
  }

  inbound_rule {
    action = "accept"
    port   = 443
    ip_range     = "0.0.0.0/0"
  }

  inbound_rule {
    action = "accept"
    port   = 22
    ip_range     = "::/0"
  }

  inbound_rule {
    action = "accept"
    port   = 80
    ip_range     = "::/0"
  }

  inbound_rule {
    action = "accept"
    port   = 443
    ip_range     = "::/0"
  }

  inbound_rule {
    action = "accept"
    port   = 6443
    ip_range     = "172.16.0.0/24"
  }
  
  inbound_rule {
    action = "accept"
    port   = 6443
    ip_range     = "172.16.0.0/24"
  }
  
  inbound_rule {
    action = "accept"
    port   = 8472
    ip_range     = "172.16.0.0/24"
  }
  
  inbound_rule {
    action = "accept"
    port   = 10250
    ip_range     = "172.16.0.0/24"
  }
  
  inbound_rule {
    action = "accept"
    port   = 51820
    ip_range     = "172.16.0.0/24"
  }
}
