resource "tls_private_key" "generated_keys" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "public_key" {
    file_permission = "0400"
    filename = "keys/login.pub"
    content = tls_private_key.generated_keys.public_key_openssh
}

resource "local_sensitive_file" "private_key" {
    file_permission = "0400"
    filename = "keys/login.pem"
    content = tls_private_key.generated_keys.private_key_openssh
}

resource "aws_key_pair" "name" {
    key_name = "login"
    public_key = tls_private_key.generated_keys.public_key_openssh
}

resource "aws_instance" "custom_ec2" {
    subnet_id = var.subnetid
    ami = var.ami
    instance_type = var.ec2_size

    key_name = aws_key_pair.name.key_name

    root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.volumetype
    delete_on_termination = true
    }

    ebs_block_device {
      volume_size = var.volumesize
      volume_type = var.volumetype
      device_name = "/dev/sdh"
      delete_on_termination = false
    }
    security_groups = [ var.security_grp ]
    tags = {
      "Name" = var.ec2_name
    }
}