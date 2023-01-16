resource "ovh_domain_zone_record" "a_record" {
  for_each  = var.az.k3s_master
  zone      = "pewty.xyz"
  subdomain = "master.k3s.default"
  fieldtype = "A"
  ttl       = "60"
  target    = each.value.private_ip
}
