resource "aws_s3_bucket" "wafo_log_bucket" {
    bucket = var.bucket_name
    acl = var.s3_acl
    force_destroy = true
    
/*    lifecycle_rule {
        id      = "log"
        enabled = true
        
        prefix = "${aws_s3_bucket.wafo_log_bucket.arn}/*"
        
        tags = {
            rule      = "log"
            autoclean = "true"
        }
        transition {
            days          = 30
            storage_class = "STANDARD_IA" # or "ONEZONE_IA"
        } */
}

resource "aws_s3_bucket_policy" "wafo_s3_policy" {
  bucket = aws_s3_bucket.wafo_log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::600734575887:root"
        },
        "Action": "s3:PutObject",
        "Resource": "${aws_s3_bucket.wafo_log_bucket.arn}/*"
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "delivery.logs.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "${aws_s3_bucket.wafo_log_bucket.arn}/*",
        "Condition": {
          "StringEquals": {
            "s3:x-amz-acl": "bucket-owner-full-control"
          }
        }
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "delivery.logs.amazonaws.com"
        },
        "Action": "s3:GetBucketAcl",
        "Resource": "${aws_s3_bucket.wafo_log_bucket.arn}"
      },
      {
        "Effect": "Allow",
        "Principal": {
            "Service": "logs.ap-northeast-2.amazonaws.com"
        },
        "Action": "s3:GetBucketAcl",
        "Resource": "${aws_s3_bucket.wafo_log_bucket.arn}"
      },
      {
        "Effect": "Allow",
        "Principal": {
            "Service": "logs.ap-northeast-2.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": "${aws_s3_bucket.wafo_log_bucket.arn}/*",
        "Condition": {
            "StringEquals": {
                "s3:x-amz-acl": "bucket-owner-full-control"
            }
        }
      }
    ]
  })
}
resource "aws_s3_bucket_public_access_block" "wafo_access_bucket" {
  bucket = aws_s3_bucket.wafo_log_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_ebs_volume" "wafo_ebs" {
  availability_zone = "${var.region}${var.ava_zone[0]}"
  size              = 20

  tags = {
    Name = "${var.name}-ebs"
  }
}

resource "aws_volume_attachment" "wafo_ebs_att" {
  device_name = var.device_name
  volume_id   = aws_ebs_volume.wafo_ebs.id
  instance_id = aws_instance.wafo_bastion.id
  force_detach = true
  skip_destroy = true
}

resource "aws_efs_file_system" "wafo_efs" {
  creation_token = "${var.name}-efs"

  tags = {
    Name = "${var.name}-efs"
  }
}
resource "aws_efs_mount_target" "wafo_efs_mount" {
    count = 2
    file_system_id = aws_efs_file_system.wafo_efs.id
    subnet_id = aws_subnet.wafo_priwas[count.index].id
    security_groups = [aws_security_group.sg_efs.id]
}