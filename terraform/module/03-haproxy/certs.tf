data "ovh_domain_zone" "rootzone" {
  name = "pewty.xyz"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.default_user.email
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.registration.account_key_pem
  common_name     = data.ovh_domain_zone.rootzone.id
  subject_alternative_names = ["*.pewty.xyz", "*.${data.scaleway_account_project.by_project_id.name}.pewty.xyz"]

  dns_challenge {
    provider = "ovh"
    config = {
      OVH_ENDPOINT = "ovh-eu"
      OVH_TTL      = "60"
    }
  }

  recursive_nameservers        = ["8.8.8.8:53", "8.8.4.4:53"]
  disable_complete_propagation = true

  depends_on = [acme_registration.registration]
}

resource "aws_s3_object" "certs" {
  bucket  = "pewty-instance-config"
  key     = "cert.pem"
  content = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}${acme_certificate.certificate.private_key_pem}"
  etag    = md5("${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}${acme_certificate.certificate.private_key_pem}")

  tags = {
    update = "yes"
  }
}
