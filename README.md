# Reference
Terraform with Ansible to create/manage a NFS over TLS server and client for testing/showcase. Tested with CentOS 7.

# Requirements
- Terraform installed.
- AWS credentials (e.g. `aws configure` if awscli is installed)
- Customized variables, see: Variables section.
- PEM key/certificate, see: Certificate section.

# Variables
Edit the vars file (.tfvars) to customize the deployment, especially:

**bucket_name**

- a unique bucket name, terraform will create the bucket to store various resources.

**mgmt_cidr**

- an IP range granted NiFi webUI and EC2 SSH access via the ELB hostname.
- deploying from home? `dig +short myip.opendns.com @resolver1.opendns.com | awk '{ print $1"/32" }'`

**kms_manager**

- an AWS user account (not root) that will be granted access to the KMS key (to read S3 objects).

- Don't have an IAM user? Replace all occurrences of `${data.aws_iam_user.tf-nifi-kmsmanager.arn}` with a role ARN (e.g. an Instance Profile ARN), and remove the `aws_iam_user` block in tf-nifi-generic.tf.

**instance_key**

- a public SSH key for SSH access to instances.

**nfs_size_gb**

- the size of the block device to share via NFS over TLS. It must be a unique size for the server to identify the block device.

# Certificate
Generate a key/certificate pair, the key is stored in the encrypted S3 bucket and the (also encrypted) EC2 instances.
```
# Generate certificate and key, note valid days, set subj field as desired.
openssl req -x509 -newkey rsa:2049 -days 1500 -nodes \
-out nfs-cert.pem -keyout tls-nfs.pem \
-subj "/C=US/ST=Florida/L=Tampa/O=chadg.net/emailAddress=chad@chadg.net/CN=nfstls"

# Append certificate to key file
cat nfs-cert.pem >> tls-nfs.pem

# Place in playbook directory
mv tls-nfs.pem playbook/tls-nfs.pem

# Remove certificate file
rm nfs-cert.pem
```

# Deploy
```
# Initialize terraform
terraform init

# Apply terraform - the first apply takes a while creating encrypted AMI(s).
terraform apply -var-file="tls_nfs.tfvars"
```
