variable "pool" {
  type = map(object({
    ip      = string
    netmask = string
    db = map(object({
      ip   = string
    }))
    vpn = map(object({
      ip   = string
    }))
    k3s_master = map(object({
      ip   = string
    }))
    k3s_worker = map(object({
      ip   = string
    }))
  }))
  default = {
    "default" = {
      ip      = "172.16.0.0"
      netmask = "24"
      db = {
        "db-01" = {
          ip   = "172.16.0.1"
        }
      }
      vpn = {
        "vpn-01" = {
          ip   = "172.16.0.10"
        }
      }
      k3s_master = {
        "k3s-master-01" = {
          ip   = "172.16.0.20"
        }
      }
      k3s_worker = {
        "k3s-worker-01" = {
          ip   = "172.16.0.30"
        },
      }
    }
  }
  description = "List of instances in a given network"
}
