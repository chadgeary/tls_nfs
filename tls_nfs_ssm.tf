# server
resource "aws_ssm_association" "tls-nfs-server-ssm-assoc" {
  association_name        = "tls-nfs-server"
  name                    = "AWS-ApplyAnsiblePlaybooks"
  targets {
    key                   = "tag:NFS"
    values                = ["server"]
  }
  output_location {
    s3_bucket_name          = aws_s3_bucket.tls-nfs-bucket.id
    s3_key_prefix           = "ssm"
  }
  parameters              = {
    Check                   = "False"
    ExtraVariables          = "SSM=True nfs_size_gb=${var.nfs_size_gb} nfs_mount_path=${var.nfs_mount_path} nfs_fs_type=${var.nfs_fs_type} nfs_export_cidr=${var.pubnet1_cidr} server_port=${var.server_port}"
    InstallDependencies     = "False"
    PlaybookFile            = "server.yml"
    SourceInfo              = "{\"path\":\"https://s3.${var.aws_region}.amazonaws.com/${aws_s3_bucket.tls-nfs-bucket.id}/playbook/\"}"
    SourceType              = "S3"
    Verbose                 = "-v"
  }
}

# client
resource "aws_ssm_association" "tls-nfs-client-ssm-assoc" {
  association_name        = "tls-nfs-client"
  name                    = "AWS-ApplyAnsiblePlaybooks"
  targets {
    key                   = "tag:NFS"
    values                = ["client"]
  }
  output_location {
    s3_bucket_name          = aws_s3_bucket.tls-nfs-bucket.id
    s3_key_prefix           = "ssm"
  }
  parameters              = {
    Check                   = "False"
    ExtraVariables          = "SSM=True nfs_mount_path=${var.nfs_mount_path} server_ip=${var.server_ip} server_port=${var.server_port}"
    InstallDependencies     = "False"
    PlaybookFile            = "client.yml"
    SourceInfo              = "{\"path\":\"https://s3.${var.aws_region}.amazonaws.com/${aws_s3_bucket.tls-nfs-bucket.id}/playbook/\"}"
    SourceType              = "S3"
    Verbose                 = "-v"
  }
}
