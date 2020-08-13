resource "aws_kms_key" "tls-nfs-kmscmk-s3" {
  description             = "Key for tls-nfs s3"
  key_usage               = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation     = "true"
  tags                    = {
    Name                  = "tls-nfs-kmscmk-s3"
  }
  policy                  = <<EOF
{
  "Id": "tls-nfs-kmskeypolicy-s3",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_iam_user.tls-nfs-kmsmanager.arn}"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow EC2 Encrypt",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.tls-nfs-instance-iam-role.arn}"
      },
      "Action": [
        "kms:Encrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "${data.aws_caller_identity.tls-nfs-aws-account.account_id}",
          "kms:ViaService": "ec2.${var.aws_region}.amazonaws.com"
        }
      }
    },
    {
      "Sid": "Allow access through S3",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.tls-nfs-instance-iam-role.arn}"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "${data.aws_caller_identity.tls-nfs-aws-account.account_id}",
          "kms:ViaService": "s3.${var.aws_region}.amazonaws.com"
        }
      }
    }
  ]
}
EOF
}

resource "aws_kms_alias" "tls-nfs-kmscmk-s3-alias" {
  name                    = "alias/tls-nfs-ksmcmk-s3"
  target_key_id           = aws_kms_key.tls-nfs-kmscmk-s3.key_id
}
