resource "aws_s3_object" "k3s_worker" {
  for_each = var.az.k3s_worker
  bucket   = "pewty-instance-config"
  key      = "${var.scw_instance.k3s_worker[each.key].name}/wg.sh"
  content  = ""
  tags = {
    update = "yes"
  }
}
