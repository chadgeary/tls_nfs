# aws profile (e.g. from aws configure, usually "default")
aws_profile = "default"
aws_region = "us-east-1"

# existing aws iam user granted access to the kms key (for browsing KMS encrypted services like S3 or SNS).
kms_manager = "some_iam_user"

# the subnet permitted to ssh to instances
mgmt_cidr = "127.0.0.0/30"

# a unique bucket name to store various input/output
bucket_name = "some-bucket-abc123"

# public ssh key
instance_key = "ssh-rsa AAAAB3NzaD2yc2EAAAADAQABAAABAQCNsxnMWfrG3SoLr4uJMavf43YkM5wCbdO7X5uBvRU8oh1W+A/Nd/jie2tc3UpwDZwS3w6MAfnu8B1gE9lzcgTu1FFf0us5zIWYR/mSoOFKlTiaI7Uaqkc+YzmVw/fy1iFxDDeaZfoc0vuQvPr+LsxUL5UY4ko4tynCSp7zgVpot/OppqdHl5J+DYhNubm8ess6cugTustUZoDmJdo2ANQENeBUNkBPXUnMO1iulfNb6GnwWJ0Z5TRRLGSu2gya2wMLeo1rBJ5cbZZgVLMVHiKgwBy/svUQreR8R+fpVW+Q4rx6sPAltLaOUONn0SF2BvvJUueqxpAIaA2rU4MS420P"

# the instance type to deploy
instance_type = "t3a.small"

# details of the nfs block device and share
# the size must be unique to the server to properly identify the block device
nfs_size_gb = 13
nfs_device_suffix = "sdg"
nfs_mount_path = "/mnt/tls_nfs"
nfs_fs_type = "xfs"

# the vendor supplying the AMI and the AMI name - defaults are official centos 7 
centos_ami_account_number = "125523088429"
centos_ami_name_string = "CentOS 7.* x86_64"
centos_ami_name_tag = "tls-nfs-encrypted-centos-ami"

# vpc specific vars, modify these values if there would be overlap with existing resources.
vpc_cidr = "10.10.0.0/23"
pubnet1_cidr = "10.10.1.0/24"
server_ip = "10.10.1.10"
server_port = "20490"
encrypted_ami_ip = "10.10.1.9"
