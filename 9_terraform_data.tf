resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {  
  key_name   = "terraform"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.key_pair.private_key_pem
  filename = "${path.module}/terraform.pem"
  file_permission = "0400"
}

resource "terraform_data" "bastion" {
  depends_on = [ local_file.private_key ]
  connection {
    host = aws_instance.bastion.public_ip
    user = "ubuntu"
    type = "ssh"
    private_key = tls_private_key.key_pair.private_key_pem
    timeout = "2m"
  }

  provisioner "file" {
    source = "${path.module}/terraform.pem"
    destination = "/home/ubuntu/terraform.pem"
  }
}