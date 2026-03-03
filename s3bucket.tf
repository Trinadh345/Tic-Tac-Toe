
resource "aws_s3_bucket" "my_devops_bucket" {
  bucket        = "trinadh01-devops-project-2026"
  force_destroy = true
}
