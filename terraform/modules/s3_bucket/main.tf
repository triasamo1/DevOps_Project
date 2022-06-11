# Create an S3 bucket
resource "aws_s3_bucket" "s3_bucket_storage" {
    bucket = "s3bucketstorage"
}

# Make the S3 bucket private
resource "aws_s3_bucket_acl" "example" {
    bucket = aws_s3_bucket.s3_bucket_storage.id
    acl    = "private"
}