# s3 bucket
resource "aws_s3_bucket" "tls-nfs-bucket" {
  bucket                  = var.bucket_name
  acl                     = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.tls-nfs-kmscmk-s3.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# s3 block all public access to bucket
resource "aws_s3_bucket_public_access_block" "tls-nfs-bucket-pubaccessblock" {
  bucket                  = aws_s3_bucket.tls-nfs-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# s3 objects (ssm playbook)
resource "aws_s3_bucket_object" "tls-nfs-playbook-objects" {
  for_each                = fileset("playbook/", "*")
  bucket                  = aws_s3_bucket.tls-nfs-bucket.id
  key                     = "playbook/${each.value}"
  source                  = "playbook/${each.value}"
  etag                    = filemd5("playbook/${each.value}")
}
