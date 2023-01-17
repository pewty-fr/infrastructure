region              = "fr-par"
zone                = "fr-par-1"
project             = "a26a2ce4-2fbf-4cde-8e06-3d2dd3d962d7"
image               = "ubuntu-k3s-pewty-17-01-2023-17-09"
netmaker_access_key = "9713240081e6962a"
wg_iface            = "nm-default"
instance_state      = "stopped"

pool = {
  net  = "172.17.0.0"
  mask = "16"
  AZs = {
    "AZ_A" = {
      wg_net       = "172.17.0.0"
      wg_mask      = "24"
      private_net  = "172.16.0.0"
      private_mask = "24"
      db = {
        "db-01" = {
          wg_ip      = "172.17.0.1"
          private_ip = "172.16.0.1"
        }
      }
      k3s_master = {
        "k3s-master-01" = {
          wg_ip      = "172.17.0.10"
          private_ip = "172.16.0.10"
        }
      }
      k3s_worker = {
        "k3s-worker-01" = {
          wg_ip      = "172.17.0.13"
          private_ip = "172.16.0.13"
        }
      }
    }
  }
}

external_device = {
  ep_hp = {
    wg_ip = "172.17.0.230"
  }
}
