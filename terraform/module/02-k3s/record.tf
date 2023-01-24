locals {
  public_a = flatten([
    for k1, app in var.applications :
    [
      for k2, server in scaleway_instance_ip.ip :
      {
        ip     = server.address
        domain = app.domain
      } if app.is_public
    ]
  ])
  public_aaaa = flatten([
    for app in var.applications :
    [
      for server in scaleway_instance_server.k3s_master :
      {
        ip     = server.ipv6_address
        domain = app.domain
      } if app.is_public
    ]
  ])
  private_a = flatten([
    for app in var.applications :
    [
      for server in var.az.k3s_master :
      {
        ip     = server.private_ip
        domain = app.domain
      } if !app.is_public
    ]
  ])
  private_aaaa = flatten([
    for app in var.applications :
    [
      for server in var.az.k3s_master :
      {
        ip     = server.private_ip_v6
        domain = app.domain
      } if !app.is_public
    ]
  ])
}

resource "ovh_domain_zone_record" "a_public_record" {
  for_each  = { for record in local.public_a : "${record.domain}-${record.ip}" => record }
  zone      = "pewty.xyz"
  subdomain = "${each.value.domain}.${data.scaleway_account_project.by_project_id.name}"
  fieldtype = "A"
  ttl       = "60"
  target    = each.value.ip
}

resource "ovh_domain_zone_record" "aaaa_public_record" {
  for_each  = { for record in local.public_aaaa : "${record.domain}-${record.ip}" => record }
  zone      = "pewty.xyz"
  subdomain = "${each.value.domain}.${data.scaleway_account_project.by_project_id.name}"
  fieldtype = "AAAA"
  ttl       = "60"
  target    = each.value.ip
}

resource "ovh_domain_zone_record" "a_private_record" {
  for_each  = { for record in local.private_a : "${record.domain}-${record.ip}" => record }
  zone      = "pewty.xyz"
  subdomain = "${each.value.domain}.${data.scaleway_account_project.by_project_id.name}"
  fieldtype = "A"
  ttl       = "60"
  target    = each.value.ip
}

resource "ovh_domain_zone_record" "aaaa_private_record" {
  for_each  = { for record in local.private_aaaa : "${record.domain}-${record.ip}" => record }
  zone      = "pewty.xyz"
  subdomain = "${each.value.domain}.${data.scaleway_account_project.by_project_id.name}"
  fieldtype = "AAAA"
  ttl       = "60"
  target    = each.value.ip
}


resource "ovh_domain_zone_record" "a_record" {
  for_each  = var.az.k3s_master
  zone      = "pewty.xyz"
  subdomain = "master.k3s.default"
  fieldtype = "A"
  ttl       = "60"
  target    = each.value.private_ip
}

# resource "ovh_domain_zone_record" "grafana" {
#   for_each  = scaleway_instance_ip.ip
#   zone      = "pewty.xyz"
#   subdomain = "grafana.default"
#   fieldtype = "A"
#   ttl       = "60"
#   target    = each.value.address
# }

# resource "ovh_domain_zone_record" "alertmanager" {
#   for_each  = var.az.k3s_master
#   zone      = "pewty.xyz"
#   subdomain = "alertmanager.default"
#   fieldtype = "A"
#   ttl       = "60"
#   target    = each.value.private_ip
# }

# resource "ovh_domain_zone_record" "dashboard" {
#   for_each  = var.az.k3s_master
#   zone      = "pewty.xyz"
#   subdomain = "dashboard.default"
#   fieldtype = "A"
#   ttl       = "60"
#   target    = each.value.private_ip
# }

# resource "ovh_domain_zone_record" "authentik" {
#   for_each  = scaleway_instance_ip.ip
#   zone      = "pewty.xyz"
#   subdomain = "authentik.default"
#   fieldtype = "A"
#   ttl       = "60"
#   target    = each.value.address
# }


# resource "ovh_domain_zone_record" "gitea" {
#   for_each  = scaleway_instance_ip.ip
#   zone      = "pewty.xyz"
#   subdomain = "gitea.default"
#   fieldtype = "A"
#   ttl       = "60"
#   target    = each.value.address
# }

