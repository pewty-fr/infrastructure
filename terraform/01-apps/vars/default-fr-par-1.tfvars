region         = "fr-par"
zone           = "fr-par-1"
project        = "a26a2ce4-2fbf-4cde-8e06-3d2dd3d962d7"

default_user = {
  username = "tanguy.falconnet"
  email    = "tanguy.falconnet@pewty.fr"
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
  echoip = {
    domain    = "ip"
    is_public = true
  }
  uptimekuma = {
    domain    = "status"
    is_public = true
    zone = "pewty.fr"
  }
  ntfy = {
    domain    = "notify"
    is_public = true
    zone = "pewty.xyz"
  }
}
