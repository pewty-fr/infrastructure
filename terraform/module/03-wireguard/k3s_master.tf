resource "wireguard_asymmetric_key" "master" {
  for_each = var.az.k3s_master
}

resource "aws_s3_object" "k3s_master" {
  for_each = var.az.k3s_master
  bucket   = "pewty-instance-config"
  key      = "${var.wg_server.k3s_master[each.key].name}/wg.sh"
  content = templatefile("${path.module}/templates/wg.sh", {
    WG_CONF = templatefile("${path.module}/templates/wg.conf", {
      WG_IP             = each.value.wg_ip
      WG_PRIV_KEY       = wireguard_asymmetric_key.master[each.key].private_key
      MASTER_PEERS      = { for k, v in var.az.k3s_master : k => v if k != each.key }
      MASTER_KEYS       = wireguard_asymmetric_key.master
      WORKER_PEERS      = var.az.k3s_worker
      WORKER_KEYS       = wireguard_asymmetric_key.worker
      OUTSIDE_PEERS     = []
      OUTSIDE_NETWORKS  = []
      OUTSIDE_PUB_KEYS  = []
      EXTERNAL_DEVICE   = var.external_device
      EXTERNAL_PUB_KEYS = wireguard_asymmetric_key.external
      POSTUP            = "iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ens2 -j MASQUERADE"
      POSTDOWN          = "iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ens2 -j MASQUERADE"
    })
  })
  tags = {
    update = "no"
  }
}
