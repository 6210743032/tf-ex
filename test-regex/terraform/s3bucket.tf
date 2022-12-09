# create s3 bucket
resource "aws_s3_bucket" "custom-s3-bucket-01" {
    bucket = "custom-s3-bucket-01"
    tags = {
      name = "bucket_demo"
    }
}

# ควบคุมการเข้่าถึง 
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.custom-s3-bucket-01.id
  acl = "private" 
}