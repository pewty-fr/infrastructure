resource "ovh_domain_zone_record" "a_record" {
  for_each  = scaleway_instance_ip.ip
  zone      = "pewty.xyz"
  subdomain = "*.netmaker"
  fieldtype = "A"
  ttl       = "60"
  target    = each.value.address
}

resource "ovh_domain_zone_record" "aaaa_record" {
  for_each  = scaleway_instance_server.netmaker
  zone      = "pewty.xyz"
  subdomain = "*.netmaker"
  fieldtype = "AAAA"
  ttl       = "60"
  target    = each.value.ipv6_address
}


