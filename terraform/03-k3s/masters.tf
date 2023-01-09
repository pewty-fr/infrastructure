
module "instance_pool" {
  source = "../_common/instance-pool"
}

data "scaleway_instance_image" "master" {
  name = var.master_image
}

resource "scaleway_instance_ip" "ip" {
  for_each = module.instance_pool.pools[data.scaleway_account_project.by_project_id.name].k3s_master
}

resource "scaleway_instance_server" "k3s_master" {
  for_each = module.instance_pool.pools[data.scaleway_account_project.by_project_id.name].k3s_master
  name     = "pewty-${data.scaleway_account_project.by_project_id.name}-${each.key}"
  image    = data.scaleway_instance_image.master
  type     = "DEV1-S"
  ip_id    = scaleway_instance_ip.ip[each.key].id

  private_network {
    pn_id = data.terraform_remote_state.network.outputs.private_network_id
  }
  user_data = {
    cloud-init = templatefile("${path.module}/templates/cloud-init.sh", {
      PRIVATE_NET_IP = "${each.value.ip}/${module.instance_pool.pools[data.scaleway_account_project.by_project_id.name].netmask}"
      DOCKER_COMPOSE = templatefile("${path.module}/templates/docker-compose.yml", {
        NETMAKER_BASE_DOMAIN      = "netmaker.pewty.xyz"
        SERVER_PUBLIC_IP          = scaleway_instance_ip.ip[each.key].address
        REPLACE_MASTER_KEY        = random_password.master_key.result
        SQL_HOST                  = data.terraform_remote_state.network.outputs.db_k3s.host
        SQL_PORT                  = data.terraform_remote_state.network.outputs.db_k3s.port
        SQL_DB                    = data.terraform_remote_state.network.outputs.db_k3s.name
        SQL_USER                  = data.terraform_remote_state.network.outputs.db_k3s.user
        SQL_PASS                  = data.terraform_remote_state.network.outputs.db_k3s.password
        NODE_ID                   = each.key
        REPLACE_MQ_ADMIN_PASSWORD = random_password.mq.result
      })
    })
  }
}
