rule "aws_s3_bucket_name" {
  enabled = true
  regex = "(?!(^xn--|.+-s3alias$))(?!.*[.]{2})(?!^(\d+.)+\d+$)^[a-z0-9][a-z0-9-.]{1,61}[a-z0-9]$"
  prefix = "my-org"
}

resource "aws_s3_bucket" "foo" {
  bucket = "foo"
}