resource "aws_s3_object" "k3s_master" {
  bucket  = "pewty-instance-config"
  key     = "${var.k3s_master_name}/kubernetes-apps.sh"
  content = templatefile("${path.module}/templates/kubernetes-apps.sh", {
    VM_STACK = templatefile("${path.module}/templates/vm-stack.values.yaml", {})
  })
  etag    = md5(templatefile("${path.module}/templates/kubernetes-apps.sh", {
    VM_STACK = templatefile("${path.module}/templates/vm-stack.values.yaml", {})
  }))
  tags = {
    update = "yes"
  }
}
