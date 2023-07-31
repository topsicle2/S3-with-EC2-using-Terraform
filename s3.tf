resource "aws_s3_bucket" "interquest" {
  bucket = "interquest"
  
  tags = {
    Name        = "Interview-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "example" {
  key    = "mjobject"
  bucket = "interquest"
  source = "example.sh"
  #kms_key_id = aws_kms_key.examplekms.arn

    depends_on = [ aws_s3_bucket.interquest ]
}

# }
# resource "aws_s3_bucket_acl" "mjbucket-acl" {
#   bucket = "inter-quest"
#   acl    = "private"
# }

# resource "aws_s3_bucket_versioning" "mjbucket-versioning" {
#   bucket = inter-quest
#   versioning_configuration {
#     status = "Enabled"
#   }
# }



# resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
#   bucket = mjbucket.id

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = aws_kms_key.mykey.arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }
