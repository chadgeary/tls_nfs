variable "aws_region" {
  type                     = string
}

variable "aws_profile" {
  type                     = string
}

variable "vpc_cidr" {
  type                     = string
}

variable "pubnet1_cidr" {
  type                     = string
}

variable "encrypted_ami_ip" {
  type                     = string
  description              = "An ip from pubnet_cidr to build a short-lived EC2 instance with CMK encryption"
}

variable "server_ip" {
  type                     = string
  description              = "An ip from pubnet_cidr for the NFS server"
}

variable "server_port" {
  type                     = string
  description              = "A port used to export the NFS to from server to clients"
}

variable "mgmt_cidr" {
  type                     = string
  description              = "Subnet CIDR allowed to access NiFi instance(s) via ELB, e.g. 172.16.10.0/30"
}

variable "instance_type" {
  type                     = string
  description              = "The type of EC2 instance to deploy"
}

variable "instance_key" {
  type                     = string
  description              = "A public key for SSH access to instance(s)"
}

variable "kms_manager" {
  type                     = string
  description              = "An IAM user for management of KMS key"
}

variable "bucket_name" {
  type                     = string
  description              = "A unique bucket name to store playbooks and output of SSM"
}

variable "centos_ami_name_tag" {
  type                     = string
  description              = "The KMS CMK-encrypted AMI's name and name tag"
}

variable "centos_ami_account_number" {
  type                     = string
  description              = "The account number of the vendor supplying the base AMI"
}

variable "centos_ami_name_string" {
  type                     = string
  description              = "The search string for the name of the AMI from the AMI Vendor"
}

variable "ubuntu_ami_name_tag" {
  type                     = string
  description              = "The KMS CMK-encrypted AMI's name and name tag"
}

variable "ubuntu_ami_account_number" {
  type                     = string
  description              = "The account number of the vendor supplying the base AMI"
}

variable "ubuntu_ami_name_string" {
  type                     = string
  description              = "The search string for the name of the AMI from the AMI Vendor"
}

variable "nfs_size_gb" {
  type                     = number
  description              = "The size of the ebs volume in GiB to be shared via NFS/TLS"
}

variable "nfs_device_suffix" {
  type                     = string
  description              = "The name of the block device presented to the instance, e.g. /dev/sdg"
}

variable "nfs_mount_path" {
  type                     = string
  description              = "The path NFS will be mounted to."
}

variable "nfs_fs_type" {
  type                     = string
  description              = "FS type, e.g. xfs or ext4"
}

provider "aws" {
  region                   = var.aws_region
  profile                  = var.aws_profile
}

# region azs
data "aws_availability_zones" "tls-nfs-azs" {
  state                    = "available"
}

# account id
data "aws_caller_identity" "tls-nfs-aws-account" {
}

# kms cmk manager - granted read access to KMS CMKs
data "aws_iam_user" "tls-nfs-kmsmanager" {
  user_name               = var.kms_manager
}
