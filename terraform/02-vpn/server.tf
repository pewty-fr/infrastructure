data "scaleway_instance_image" "netmaker" {
  name = var.image
}

resource "random_password" "master_key" {
  length = 30
  override_special = "*?@!-_=+:" 
}

resource "random_password" "mq" {
  length = 30
  override_special = "*?@!-_=+:" 
}

resource "scaleway_instance_ip" "ip" {
  for_each = module.instance_pool.pools[data.scaleway_account_project.by_project_id.name].vpn
}

resource "scaleway_instance_server" "netmaker" {
  for_each    = module.instance_pool.pools[data.scaleway_account_project.by_project_id.name].vpn
  name        = "pewty-${data.scaleway_account_project.by_project_id.name}-${each.key}"
  image       = data.scaleway_instance_image.netmaker.image_id
  enable_ipv6 = true
  type        = "DEV1-S"
  ip_id       = scaleway_instance_ip.ip[each.key].id

  private_network {
    pn_id = data.terraform_remote_state.network.outputs.private_network_id
  }
  user_data = {
    cloud-init = templatefile("${path.module}/templates/cloud-init.sh", {
      ENS5 = templatefile("${path.module}/templates/60-ens5-vpc.yaml", {
        PRIVATE_NET_IP = each.value.ip
        PRIVATE_NETMASK = module.instance_pool.pools[data.scaleway_account_project.by_project_id.name].netmask
      })
      CADDYFILE = templatefile("${path.module}/templates/Caddyfile", {
        EMAIL                = "tanguy.falconnet@pewty.fr"
        NETMAKER_BASE_DOMAIN = "netmaker.pewty.xyz"
      })
      DOCKER_COMPOSE = templatefile("${path.module}/templates/docker-compose.yml", {
        NETMAKER_BASE_DOMAIN      = "netmaker.pewty.xyz"
        SERVER_PUBLIC_IP          = scaleway_instance_ip.ip[each.key].address
        REPLACE_MASTER_KEY        = random_password.master_key.result
        SQL_HOST                  = data.terraform_remote_state.db.outputs.db_vpn.host
        SQL_PORT                  = data.terraform_remote_state.db.outputs.db_vpn.port
        SQL_DB                    = data.terraform_remote_state.db.outputs.db_vpn.name
        SQL_USER                  = data.terraform_remote_state.db.outputs.db_vpn.user
        SQL_PASS                  = data.terraform_remote_state.db.outputs.db_vpn.password
        NODE_ID                   = each.key
        REPLACE_MQ_ADMIN_PASSWORD = random_password.mq.result
      })
    })
  }
}
