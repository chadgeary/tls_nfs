#!/bin/bash
# pip and unzip
yum -y install python3-pip unzip

# ansible
pip3 install ansible

# ssm
yum -y install https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
