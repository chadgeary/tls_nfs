# security groups
resource "aws_security_group" "tls-nfs-sg-server" {
  name                    = "tls-nfs-sg-server"
  description             = "Security group for public traffic"
  vpc_id                  = aws_vpc.tls-nfs-vpc.id
  tags = {
    Name = "tls-nfs-sg-server"
  }
}

resource "aws_security_group" "tls-nfs-sg-clients" {
  name                    = "tls-nfs-sg-clients"
  description             = "Security group for public traffic"
  vpc_id                  = aws_vpc.tls-nfs-vpc.id
  tags = {
    Name = "tls-nfs-sg-clients"
  }
}

# security group rules
resource "aws_security_group_rule" "tls-nfs-sg-server-mgmt-ssh-in" {
  security_group_id       = aws_security_group.tls-nfs-sg-server.id
  type                    = "ingress"
  description             = "IN FROM MGMT - SSH MGMT"
  from_port               = "22"
  to_port                 = "22"
  protocol                = "tcp"
  cidr_blocks             = [var.mgmt_cidr]
}

resource "aws_security_group_rule" "tls-nfs-sg-server-world-http-out" {
  security_group_id       = aws_security_group.tls-nfs-sg-server.id
  type                    = "egress"
  description             = "OUT TO WORLD - HTTP YUM"
  from_port               = "80"
  to_port                 = "80"
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "tls-nfs-sg-server-world-https-out" {
  security_group_id       = aws_security_group.tls-nfs-sg-server.id
  type                    = "egress"
  description             = "OUT TO WORLD - HTTPS YUM"
  from_port               = "443"
  to_port                 = "443"
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "tls-nfs-sg-server-client-nfs-in" {
  security_group_id       = aws_security_group.tls-nfs-sg-server.id
  type                    = "ingress"
  description             = "IN FROM CLIENTS - TLS NFSv4"
  from_port               = var.server_port
  to_port                 = var.server_port
  protocol                = "tcp"
  source_security_group_id = aws_security_group.tls-nfs-sg-clients.id
}

resource "aws_security_group_rule" "tls-nfs-sg-client-mgmt-ssh-in" {
  security_group_id       = aws_security_group.tls-nfs-sg-clients.id
  type                    = "ingress"
  description             = "IN FROM MGMT - SSH MGMT"
  from_port               = "22"
  to_port                 = "22"
  protocol                = "tcp"
  cidr_blocks             = [var.mgmt_cidr]
}

resource "aws_security_group_rule" "tls-nfs-sg-client-world-http-out" {
  security_group_id       = aws_security_group.tls-nfs-sg-clients.id
  type                    = "egress"
  description             = "OUT TO WORLD - HTTP YUM"
  from_port               = "80"
  to_port                 = "80"
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "tls-nfs-sg-client-world-https-out" {
  security_group_id       = aws_security_group.tls-nfs-sg-clients.id
  type                    = "egress"
  description             = "OUT TO WORLD - HTTPS YUM"
  from_port               = "443"
  to_port                 = "443"
  protocol                = "tcp"
  cidr_blocks             = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "tls-nfs-sg-client-server-nfs-out" {
  security_group_id       = aws_security_group.tls-nfs-sg-clients.id
  type                    = "egress"
  description             = "OUT TO SERVER - TLS NFSv4"
  from_port               = var.server_port
  to_port                 = var.server_port
  protocol                = "tcp"
  source_security_group_id = aws_security_group.tls-nfs-sg-server.id
}
