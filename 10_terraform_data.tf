//key pair
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

//script
resource "terraform_data" "bastion" {
  depends_on = [ local_file.private_key ]
  connection {
    host = aws_instance.bastion.public_ip
    user = "ubuntu"
    private_key = tls_private_key.key_pair.private_key_pem
    
    timeout = "2m"
  }

  provisioner "file" {
    source = "${path.module}/terraform.pem"
    destination = "/home/ubuntu/terraform.pem"
  }

  provisioner "remote-exec" {
    inline = [ "chmod 400 /home/ubuntu/terraform.pem" ]
  }

  provisioner "remote-exec" {
    script = "./scripts/bastion.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "scp -i ~/terraform.pem -oStrictHostKeyChecking=no -r ~/nginx-installer ubuntu@${aws_instance.web-a.private_ip}:",
      "scp -i ~/terraform.pem -oStrictHostKeyChecking=no -r ~/nginx-installer ubuntu@${aws_instance.web-c.private_ip}:",
      "scp -i ~/terraform.pem -oStrictHostKeyChecking=no -r ~/python-installer ubuntu@${aws_instance.was-a.private_ip}:",
      "scp -i ~/terraform.pem -oStrictHostKeyChecking=no -r ~/python-installer ubuntu@${aws_instance.was-c.private_ip}:",
      "scp -i ~/terraform.pem -oStrictHostKeyChecking=no -r ~/postgresql-installer ubuntu@${aws_instance.db-a.private_ip}:",
      "scp -i ~/terraform.pem -oStrictHostKeyChecking=no -r ~/postgresql-installer ubuntu@${aws_instance.db-c.private_ip}:"
    ]
  }
}

resource "terraform_data" "web-a" {
  connection {
    bastion_host = aws_instance.bastion.public_ip
    bastion_user = "ubuntu"
    bastion_private_key = tls_private_key.key_pair.private_key_pem

    host = aws_instance.web-a.private_ip
    user = "ubuntu"
    private_key = tls_private_key.key_pair.private_key_pem
    
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dpkg -i ~/nginx-installer/*.deb"
    ]
  }

  provisioner "file" {
    source = "./configurations/gunicorn.conf"
    destination = "/home/ubuntu/gunicorn.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp ~/gunicorn.conf /etc/nginx/conf.d/gunicorn.conf",
      "sudo sed 's/<WEB_LB_DNS>/${aws_route53_record.web-lb.fqdn}/g' -i /etc/nginx/conf.d/gunicorn.conf",
      "sudo sed 's/<WEB_LB_PORT>/${aws_lb_listener.web.port}/g' -i /etc/nginx/conf.d/gunicorn.conf",
      "sudo sed 's/<WAS_LB_DNS>/${aws_lb.was.dns_name}/g' -i /etc/nginx/conf.d/gunicorn.conf",
      "sudo sed 's/<WAS_LB_PORT>/${aws_lb_listener.was.port}/g' -i /etc/nginx/conf.d/gunicorn.conf",
      "sudo systemctl enable --now nginx.service"
    ]
  }
}

resource "terraform_data" "web-c" {
  connection {
    bastion_host = aws_instance.bastion.public_ip
    bastion_user = "ubuntu"
    bastion_private_key = tls_private_key.key_pair.private_key_pem

    host = aws_instance.web-c.private_ip
    user = "ubuntu"
    private_key = tls_private_key.key_pair.private_key_pem
    
    timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dpkg -i ~/nginx-installer/*.deb"
    ]
  }

  provisioner "file" {
    source = "./configurations/gunicorn.conf"
    destination = "/home/ubuntu/gunicorn.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp ~/gunicorn.conf /etc/nginx/conf.d/gunicorn.conf",
      "sudo sed 's/<WEB_LB_DNS>/${aws_route53_record.web-lb.fqdn}/g' -i /etc/nginx/conf.d/gunicorn.conf",
      "sudo sed 's/<WEB_LB_PORT>/${aws_lb_listener.web.port}/g' -i /etc/nginx/conf.d/gunicorn.conf",
      "sudo sed 's/<WAS_LB_DNS>/${aws_lb.was.dns_name}/g' -i /etc/nginx/conf.d/gunicorn.conf",
      "sudo sed 's/<WAS_LB_PORT>/${aws_lb_listener.was.port}/g' -i /etc/nginx/conf.d/gunicorn.conf",
      "sudo systemctl enable --now nginx.service"
    ]
  }
}