resource "aws_s3_object" "k3s_master" {
  bucket  = "pewty-instance-config"
  key     = "${var.k3s_master_name}/kubernetes-base.sh"
  content = templatefile("${path.module}/templates/kubernetes-base.sh", {
    SECRETS = templatefile("${path.module}/templates/secrets.yaml", {
      SCW_ACCESS_KEY = base64encode(var.scw_access_key)
      SCW_SECRET_KEY = base64encode(var.scw_secret_key)
      SCW_DEFAULT_ZONE = base64encode(var.zone)
      SCW_DEFAULT_PROJECT_ID = base64encode(var.project)
    })
  })
  etag    = md5(templatefile("${path.module}/templates/kubernetes-base.sh", {
    SECRETS = templatefile("${path.module}/templates/secrets.yaml", {
      SCW_ACCESS_KEY = base64encode(var.scw_access_key)
      SCW_SECRET_KEY = base64encode(var.scw_secret_key)
      SCW_DEFAULT_ZONE = base64encode(var.zone)
      SCW_DEFAULT_PROJECT_ID = base64encode(var.project)
    })
  }))
  tags = {
    update = "yes"
  }
}
