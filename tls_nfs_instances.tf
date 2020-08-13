# Instance Key
resource "aws_key_pair" "tls-nfs-instance-key" {
  key_name                = "tls-nfs-instance-key"
  public_key              = var.instance_key
  tags                    = {
    Name                    = "tls-nfs-instance-key"
  }
}

# EBS Block for NFS
resource "aws_ebs_volume" "tls-nfs-ebs-vol1" {
  availability_zone       = data.aws_availability_zones.tls-nfs-azs.names[0]
  size                    = var.nfs_size_gb
  tags                    = {
    Name                    = "tls-nfs-ebs-vol1"
  }
  encrypted               = "true"
  kms_key_id              = aws_kms_key.tls-nfs-kmscmk-ec2.arn
}

resource "aws_volume_attachment" "tls-nfs-ebs-vol1-attach" {
  device_name             = "/dev/${var.nfs_device_suffix}"
  volume_id               = aws_ebs_volume.tls-nfs-ebs-vol1.id
  instance_id             = aws_instance.tls-nfs-instance-server.id
}

# Instance(s)
resource "aws_instance" "tls-nfs-instance-server" {
  ami                     = aws_ami_from_instance.tls-nfs-latest-centos-ami-with-cmk.id
  instance_type           = var.instance_type
  iam_instance_profile    = aws_iam_instance_profile.tls-nfs-instance-profile.name
  key_name                = aws_key_pair.tls-nfs-instance-key.key_name
  subnet_id               = aws_subnet.tls-nfs-pubnet1.id
  private_ip              = var.server_ip
  associate_public_ip_address = "true"
  vpc_security_group_ids  = [aws_security_group.tls-nfs-sg-server.id]
  tags                    = {
    Name                    = "tls-nfs-server"
    NFS                     = "server"
  }
  user_data               = file("userdata/el7ssm.sh")
  depends_on              = [aws_ebs_volume.tls-nfs-ebs-vol1]
}

resource "aws_instance" "tls-nfs-instance-client1" {
  ami                     = aws_ami_from_instance.tls-nfs-latest-centos-ami-with-cmk.id
  instance_type           = var.instance_type
  iam_instance_profile    = aws_iam_instance_profile.tls-nfs-instance-profile.name
  key_name                = aws_key_pair.tls-nfs-instance-key.key_name
  subnet_id               = aws_subnet.tls-nfs-pubnet1.id
  associate_public_ip_address = "true"
  vpc_security_group_ids  = [aws_security_group.tls-nfs-sg-clients.id]
  tags                    = {
    Name                    = "tls-nfs-client1"
    NFS                     = "client"
  }
  user_data               = file("userdata/el7ssm.sh")
  depends_on              = [aws_instance.tls-nfs-instance-server]
}
