resource "aws_s3_object" "init" {
  bucket  = "pewty-instance-config"
  key     = "init.sh"
  content = file("${path.module}/files/init.sh")
  etag    = md5(file("${path.module}/files/init.sh"))
}
