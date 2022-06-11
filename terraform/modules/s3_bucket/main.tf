# Create an S3 bucket
resource "aws_s3_bucket" "s3_bucket" {
    bucket = "s3filestorage1106"
}

# Make the S3 bucket public
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
    bucket = aws_s3_bucket.s3_bucket.id
    acl    = "public-read-write"
}