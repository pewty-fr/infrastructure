resource "wireguard_asymmetric_key" "master" {
  for_each = var.az.k3s_master
}

locals {
  k3s_master_content = { for k, v in var.az.k3s_master : k => templatefile("${path.module}/templates/wg.sh", {
    WG_CONF = templatefile("${path.module}/templates/wg.conf", {
      WG_IP             = v.wg_ip
      WG_PRIV_KEY       = wireguard_asymmetric_key.master[k].private_key
      MASTER_PEERS      = { for k1, v1 in var.az.k3s_master : k => v if k != k1 }
      MASTER_KEYS       = wireguard_asymmetric_key.master
      OUTSIDE_PEERS     = []
      OUTSIDE_NETWORKS  = ""
      OUTSIDE_PUB_KEYS  = []
      EXTERNAL_DEVICE   = var.external_device
      EXTERNAL_PUB_KEYS = wireguard_asymmetric_key.external
      POSTUP            = "iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ens2 -j MASQUERADE;"
      POSTDOWN          = "iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ens2 -j MASQUERADE;"
    })
  }) }
}

resource "aws_s3_object" "k3s_master" {
  for_each = var.az.k3s_master
  bucket   = "pewty-instance-config"
  key      = "${var.scw_instance.k3s_master[each.key].name}/wg.sh"
  content = local.k3s_master_content[each.key]
  etag = md5(local.k3s_master_content[each.key])
  tags = {
    update = "yes"
  }
}
