region         = "fr-par"
zone           = "fr-par-1"
project        = "a26a2ce4-2fbf-4cde-8e06-3d2dd3d962d7"

default_user = {
  username = "tanguy.falconnet"
  email    = "tanguy.falconnet@pewty.fr"
}

external_device = {
  ep_hp = {
    wg_ip = "172.20.0.230"
  }
  home_assistant = {
    wg_ip = "172.20.0.231"
  }
}

applications = {
  grafana = {
    domain    = "grafana"
    is_public = true
    zone = "pewty.xyz"
  }
  alertmanager = {
    domain    = "alertmanager"
    is_public = true
    zone = "pewty.xyz"
  }
  dashboard = {
    domain    = "dashboard"
    is_public = true
    zone = "pewty.xyz"
  }
  authentik = {
    domain    = "auth"
    is_public = true
    zone = "pewty.xyz"
  }
  gitea = {
    domain    = "git"
    is_public = true
    zone = "pewty.xyz"
  }
  echoip = {
    domain    = "ip"
    is_public = true
    zone = "pewty.xyz"
  }
  uptimekuma = {
    domain    = "status"
    is_public = true
    zone = "pewty.xyz"
  }
  ntfy = {
    domain    = "notify"
    is_public = true
    zone = "pewty.xyz"
  }
  hass = {
    domain    = "hass"
    is_public = true
    zone = "pewty.xyz"
  }
}
