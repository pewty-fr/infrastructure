data "scaleway_instance_image" "worker" {
  name = var.worker_image
}

resource "scaleway_instance_server" "k3s_worker" {
  for_each = module.instance_pool.pools[data.scaleway_account_project.by_project_id.name].k3s_worker
  name     = "pewty-${data.scaleway_account_project.by_project_id.name}-${each.key}"
  image    = data.scaleway_instance_image.worker
  type     = "DEV1-S"

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
        NODE_ID                   = each.key
        REPLACE_MQ_ADMIN_PASSWORD = random_password.mq.result
      })
    })
  }
}
