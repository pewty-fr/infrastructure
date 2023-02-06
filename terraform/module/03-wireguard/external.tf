locals {
  master_public = { for k, v in var.scw_instance.k3s_master : k => {
    private_ip = var.scw_instance.k3s_master[k].public_ip
    wg_ip      = var.az.k3s_master[k].wg_ip
  } }
}

resource "wireguard_asymmetric_key" "external" {
  for_each = var.external_device
}

resource "local_file" "external_conf" {
  for_each        = var.external_device
  file_permission = "0644"
  content = templatefile("${path.module}/templates/wg.conf", {
    WG_IP             = each.value.wg_ip
    WG_PRIV_KEY       = wireguard_asymmetric_key.external[each.key].private_key
    MASTER_PEERS      = local.master_public
    MASTER_KEYS       = wireguard_asymmetric_key.master
    WORKER_PEERS      = {}
    WORKER_KEYS       = {}
    OUTSIDE_PEERS     = []
    OUTSIDE_NETWORKS  = ""
    OUTSIDE_PUB_KEYS  = []
    EXTERNAL_DEVICE   = {}
    EXTERNAL_PUB_KEYS = {}
    POSTUP            = ""
    POSTDOWN          = ""
  })
  filename = "${path.root}/generated/${each.key}/wg.conf"
}

