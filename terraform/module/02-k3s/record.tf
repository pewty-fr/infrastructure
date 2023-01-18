resource "ovh_domain_zone_record" "a_record" {
  for_each  = var.az.k3s_master
  zone      = "pewty.xyz"
  subdomain = "master.k3s.default"
  fieldtype = "A"
  ttl       = "60"
  target    = each.value.private_ip
}

resource "ovh_domain_zone_record" "grafana" {
  for_each  = scaleway_instance_ip.ip
  zone      = "pewty.xyz"
  subdomain = "grafana.default"
  fieldtype = "A"
  ttl       = "60"
  target    = each.value.address
}

resource "ovh_domain_zone_record" "alertmanager" {
  for_each  = var.az.k3s_master
  zone      = "pewty.xyz"
  subdomain = "alertmanager.default"
  fieldtype = "A"
  ttl       = "60"
  target    = each.value.private_ip
}
