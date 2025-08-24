resource "aws_instance" "custom_ec2" {
    subnet_id = var.subnetid
    ami = var.ami
    instance_type = var.ec2_size

    key_name = var.sshkey_name

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