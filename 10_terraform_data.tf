locals {
  web = [aws_instance.web-a.private_ip, aws_instance.web-c.private_ip]
  was = [aws_instance.was-a.private_ip, aws_instance.was-c.private_ip]
  db = [aws_instance.db-a.private_ip, aws_instance.db-c.private_ip]
}

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

//bastion
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

//web
resource "terraform_data" "web" {
  depends_on = [ terraform_data.bastion ]
  for_each = toset(local.web)

  connection {
    bastion_host = aws_instance.bastion.public_ip
    bastion_user = "ubuntu"
    bastion_private_key = tls_private_key.key_pair.private_key_pem

    host = each.value
    # host = aws_instance.web-a.private_ip
    user = "ubuntu"
    private_key = tls_private_key.key_pair.private_key_pem
    
    timeout = "2m"
  }

  provisioner "file" {
    source = "./configurations/gunicorn.conf"
    destination = "/home/ubuntu/gunicorn.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dpkg -i ~/nginx-installer/*.deb",
      "sudo cp ~/gunicorn.conf /etc/nginx/conf.d/gunicorn.conf",
      "sudo sed 's/<WEB_LB_DNS>/${aws_route53_record.web-lb.fqdn}/g' -i /etc/nginx/conf.d/gunicorn.conf",
      "sudo sed 's/<WEB_LB_PORT>/${aws_lb_listener.web.port}/g' -i /etc/nginx/conf.d/gunicorn.conf",
      "sudo sed 's/<WAS_LB_DNS>/${aws_route53_record.was-lb.fqdn}/g' -i /etc/nginx/conf.d/gunicorn.conf",
      "sudo sed 's/<WAS_LB_PORT>/${aws_lb_listener.was.port}/g' -i /etc/nginx/conf.d/gunicorn.conf",
      "sudo systemctl enable --now nginx.service"
    ]
  }
}

//was
resource "terraform_data" "was" {
  depends_on = [ terraform_data.bastion ]
  for_each = toset(local.was)

  connection {
    bastion_host = aws_instance.bastion.public_ip
    bastion_user = "ubuntu"
    bastion_private_key = tls_private_key.key_pair.private_key_pem

    host = each.value
    user = "ubuntu"
    private_key = tls_private_key.key_pair.private_key_pem
    
    timeout = "2m"
  }

  provisioner "file" {
    source = "./packages"
    destination = "/home/ubuntu"
  }

  provisioner "file" {
    source = "./working_directory"
    destination = "/home/ubuntu"
  }

  provisioner "file" {
    source = "./configurations/gunicorn.service"
    destination = "/home/ubuntu/gunicorn.service"
  }

  provisioner "remote-exec" {
    script = "./scripts/was.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sed 's/ALLOWED_HOSTS = \\[\\]/ALLOWED_HOSTS = \\[\"${aws_route53_record.was-lb.fqdn}\"\\]/g' -i ~/working_directory/project/settings.py",
      "sed 's/<DB_NAME>/${var.db_name}/g' -i ~/working_directory/project/settings.py",
      "sed 's/<DB_USER>/${var.db_user}/g' -i ~/working_directory/project/settings.py",
      "sed 's/<DB_USER_PASSWORD>/${var.db_user_password}/g' -i ~/working_directory/project/settings.py",
      "sed 's/<DB_HOST>/${aws_route53_record.db-lb.fqdn}/g' -i ~/working_directory/project/settings.py",
      "sudo cp ~/gunicorn.service /etc/systemd/system/gunicorn.service",
      "sudo systemctl enable --now gunicorn.service"
    ]
  }
}

//db
resource "terraform_data" "db" {
  depends_on = [ terraform_data.bastion ]
  for_each = toset(local.db)

  connection {
    bastion_host = aws_instance.bastion.public_ip
    bastion_user = "ubuntu"
    bastion_private_key = tls_private_key.key_pair.private_key_pem

    host = each.value
    user = "ubuntu"
    private_key = tls_private_key.key_pair.private_key_pem
    
    timeout = "2m"
  }

  provisioner "file" {
    source = "./configurations/postgresql.sql"
    destination = "/home/ubuntu/postgresql.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dpkg -i ~/postgresql-installer/*.deb",
      "sudo sed \"s/#listen_addresses = 'localhost'/listen_addresses = '*'/g\" -i /etc/postgresql/16/main/postgresql.conf",
      "sudo sed \"s#127.0.0.1/32#0.0.0.0/0#g\" -i /etc/postgresql/16/main/pg_hba.conf",
      "sudo systemctl enable --now postgresql.service",

      "sudo -u postgres bash << EOF",
      "psql -c $'CREATE USER \"${var.db_user}\" WITH PASSWORD \\'${var.db_user_password}\\';'",
      "psql -c 'ALTER USER \"${var.db_user}\" WITH SUPERUSER;'",
      "psql -c 'CREATE DATABASE \"${var.db_name}\";'",
      "psql -c 'ALTER DATABASE \"${var.db_name}\" OWNER TO \"${var.db_user}\";'",
      "psql -c 'GRANT ALL ON DATABASE \"${var.db_name}\" TO \"${var.db_user}\" WITH GRANT OPTION;'",
      "psql -d \"${var.db_name}\" -f /home/ubuntu/postgresql.sql",
      "EOF"
    ]
  }
}