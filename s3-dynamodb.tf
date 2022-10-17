#S3 for protc=ecting the state file
resource "aws_s3_bucket" "statefile-bucket" {
  bucket = "${var.project_name}-statefile-bucket"

  versioning {
    enabled = true
  }

  tags = {
    "Name" = "${var.project_name}-statefile-bucket"
  }
}


#DynamoDB for locking the state file
#resource "aws_dynamodb_table" "dynamodb-state-lock" {
 # name           = "${var.project_name}-lock-statefile"
  #hash_key       = "LockID"
  #read_capacity  = 20
  #write_capacity = 20
  #attribute {
   #name = "LockID"
   #type = "S"
  #}
  #tags = {
   #"Name" = "State-Lock-Table"
  #}
#}

#Creating the S3 bucket for storing the artifact 

resource "aws_kms_key" "kms_macro_eyes_key" {
  deletion_window_in_days = 14
  description = "This is a key used to encrpty the bucket objects"
}

resource "aws_s3_bucket" "artifactory-s3" {
  bucket = "${var.project_name}-s3-artifactory"
  acl = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.kms_macro_eyes_key.id
        sse_algorithm = "aws:kms"
      }
    }
  }
}