# Vendor AMIs
data "aws_ami" "tls-nfs-centos-ami-latest" {
  most_recent             = true
  owners                  = ["${var.centos_ami_account_number}"]
  filter {
    name                    = "name"
    values                  = ["${var.centos_ami_name_string}"]
  }
  filter {
    name                    = "virtualization-type"
    values                  = ["hvm"]
  }
  filter {
    name                    = "architecture"
    values                  = ["x86_64"]
  }
  filter {
    name                    = "root-device-type"
    values                  = ["ebs"]
  }
}

# Copy Centos AMI to EC2 Instance for encryption
resource "aws_instance" "tls-nfs-encrypted-instance" {
  ami                     = data.aws_ami.tls-nfs-centos-ami-latest.id
  instance_type           = var.instance_type
  iam_instance_profile    = aws_iam_instance_profile.tls-nfs-instance-profile.name
  key_name                = aws_key_pair.tls-nfs-instance-key.key_name
  subnet_id               = aws_subnet.tls-nfs-pubnet1.id
  private_ip              = var.encrypted_ami_ip
  vpc_security_group_ids  = [aws_security_group.tls-nfs-sg-clients.id]
  tags                    = {
    Name                    = "tls-nfs-encrypted-instance"
  }
  root_block_device {
    encrypted               = "true"
    kms_key_id              = aws_kms_key.tls-nfs-kmscmk-ec2.arn
  }
}

# Create encrypted AMI from encrypted EC2 Instance
resource "aws_ami_from_instance" "tls-nfs-latest-centos-ami-with-cmk" {
  name                    = "tls-nfs-ami"
  description             = "KMS CMK encrypted copy of AMI (${data.aws_ami.tls-nfs-centos-ami-latest.id})"
  source_instance_id      = aws_instance.tls-nfs-encrypted-instance.id
  tags                    = {
    Name                    = "tls-nfs-ami"
  }
}
