region         = "fr-par"
zone           = "fr-par-1"
project        = "a26a2ce4-2fbf-4cde-8e06-3d2dd3d962d7"
image          = "ubuntu-k3s-pewty-20-01-2023-08-35"
instance_state = "started"

default_user = {
  username = "tanguy.falconnet"
  email    = "tanguy.falconnet@pewty.fr"
}

pool = {
  net  = "172.16.0.0"
  mask = "16"
  AZs = {
    "AZ_A" = {
      wg_net          = "172.17.0.0"
      wg_mask         = "24"
      private_net     = "172.16.0.0"
      private_mask    = "24"
      private_net_v6  = "fdce:bb07:320d::"
      private_mask_v6 = "48"
      db = {
        "db-01" = {
          private_ip = "172.16.0.1"
        }
      }
      k3s_master = {
        "k3s-master-01" = {
          wg_ip         = "172.17.0.10"
          private_ip_v6 = "fdce:bb07:320d:0000:0000:0000:0000:0010"
          private_ip    = "172.16.0.10"
        }
        "k3s-master-02" = {
          wg_ip         = "172.17.0.11"
          private_ip_v6 = "fdce:bb07:320d:0000:0000:0000:0000:0011"
          private_ip    = "172.16.0.11"
        }
      }
      k3s_worker = {
        "k3s-worker-01" = {
          wg_ip         = "172.17.0.13"
          private_ip_v6 = "fdce:bb07:320d:0000:0000:0000:0000:0013"
          private_ip    = "172.16.0.13"
        }
        "k3s-worker-02" = {
          wg_ip         = "172.17.0.14"
          private_ip_v6 = "fdce:bb07:320d:0000:0000:0000:0000:0014"
          private_ip    = "172.16.0.14"
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

applications = {
  grafana = {
    domain    = "grafana"
    is_public = true
  }
  alertmanager = {
    domain    = "alertmanager"
    is_public = false
  }
  dashboard = {
    domain    = "dashboard"
    is_public = false
  }
  authentik = {
    domain    = "auth"
    is_public = true
  }
  gitea = {
    domain    = "git"
    is_public = true
  }
}
