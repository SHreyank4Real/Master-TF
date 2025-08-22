resource "aws_key_pair" "name" {
    key_name = "login"
    public_key = tls_private_key.generated_keys.public_key_openssh
}

resource "aws_security_group" "securitygroup_for_ec2" {
    name = "allow-ssh"
    description = "This is to allow ssh from my ip"
    vpc_id = aws_vpc.custom_vpc.id
}

resource "aws_security_group_rule" "ssh-access" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.securitygroup_for_ec2.id
}

resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.securitygroup_for_ec2.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "public_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.securitygroup_for_ec2.id]
  subnet_id = aws_subnet.public_subnet_1.id
  key_name = aws_key_pair.name.key_name
  tags = {
    Name = "public_ec2"
  }
}

resource "aws_instance" "private_ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.securitygroup_for_ec2.id]
  subnet_id = aws_subnet.private_subnet_1.id
  key_name = aws_key_pair.name.key_name
  tags = {
    Name = "private_ec2"
  }
}