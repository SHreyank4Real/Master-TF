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