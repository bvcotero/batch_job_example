data "aws_s3_bucket" "snapshots" {
  bucket = "${var.bucket}"
}
