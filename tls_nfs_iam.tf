# SSM Managed Policy
data "aws_iam_policy" "tls-nfs-instance-policy-ssm" {
  arn                     = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
# Instance Policy
resource "aws_iam_policy" "tls-nfs-instance-policy" {
  name                    = "tls-nfs-instance-policy"
  path                    = "/"
  description             = "Provides tls-nfs instances access to s3 objects and ssm"
  policy                  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListObjectsinBucket",
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["${aws_s3_bucket.tls-nfs-bucket.arn}"]
    },
    {
      "Sid": "GetObjectsinBucketPrefix",
      "Effect": "Allow",
      "Action": [
        "s3:ListObject",
        "s3:GetObject"
      ],
      "Resource": ["${aws_s3_bucket.tls-nfs-bucket.arn}/playbook/*"]
    },
    {
      "Sid": "PutObjectsinBucketPrefix",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": ["${aws_s3_bucket.tls-nfs-bucket.arn}/ssm/*"]
    },
    {
      "Sid": "S3CMK",
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": ["${aws_kms_key.tls-nfs-kmscmk-s3.arn}"]
    }
  ]
}
EOF
}

# Instance Role
resource "aws_iam_role" "tls-nfs-instance-iam-role" {
  name                    = "tls-nfs-instance-profile"
  path                    = "/"
  assume_role_policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "sts:AssumeRole",
          "Principal": {
             "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
      }
  ]
}
EOF
}

# Instance Role Attachments
resource "aws_iam_role_policy_attachment" "tls-nfs-iam-attach-ssm" {
  role                    = aws_iam_role.tls-nfs-instance-iam-role.name
  policy_arn              = data.aws_iam_policy.tls-nfs-instance-policy-ssm.arn
}

resource "aws_iam_role_policy_attachment" "tls-nfs-iam-attach-custom" {
  role                    = aws_iam_role.tls-nfs-instance-iam-role.name
  policy_arn              = aws_iam_policy.tls-nfs-instance-policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "tls-nfs-instance-profile" {
  name                    = "tls-nfs-instance-profile"
  role                    = aws_iam_role.tls-nfs-instance-iam-role.name
}
