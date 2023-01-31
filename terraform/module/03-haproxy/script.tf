locals {
  haproxy_master_content = { for k, v in var.az.k3s_master : k => templatefile("${path.module}/templates/haproxy.sh", {
    CONFIG = templatefile("${path.module}/templates/haproxy.cfg", {
      PRIVATE_IP   = v.wg_ip
      PRIVATE_IPV6 = v.private_ip_v6
      PUBLIC_IP    = var.scw_instance.k3s_master[k].public_ip
      PUBLIC_IPV6  = var.scw_instance.k3s_master[k].ipv6_address
    })
    PUBLIC_MAP = templatefile("${path.module}/templates/domaintobackend.map", {
      DOMAINS = [
        for app in var.applications : "${app.domain}.${data.scaleway_account_project.by_project_id.name}.${app.zone}" if app.is_public
      ]
    })
    PRIVATE_MAP = templatefile("${path.module}/templates/domaintobackend.map", {
      DOMAINS = [
        for app in var.applications : "${app.domain}.${data.scaleway_account_project.by_project_id.name}.${app.zone}" if ! app.is_public
      ]
    })
  })}
}

# data "aws_s3_object" "haproxy_master" {
#   for_each = var.az.k3s_master
#   bucket   = "pewty-instance-config"
#   key      = "${var.scw_instance.k3s_master[each.key].name}/haproxy.sh"
# }

resource "aws_s3_object" "haproxy_master" {
  for_each = var.az.k3s_master
  bucket   = "pewty-instance-config"
  key      = "${var.scw_instance.k3s_master[each.key].name}/haproxy.sh"
  content  = local.haproxy_master_content[each.key]
  etag     = md5(local.haproxy_master_content[each.key])
  tags = {
    update = "yes" #( md5(local.haproxy_master_content[each.key]) == data.aws_s3_object.haproxy_master[each.key].etag ? "no" : "yes")
  }
}
