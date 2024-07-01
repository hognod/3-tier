module "network" {
  source = "./network"

  vpc_cidr = var.vpc_cidr
}


//tmp
resource "aws_security_group" "tmp" {
  name = "3-tier-tmp"
  tags = {
    Name = "3-tier-tmp"
  }
  vpc_id = module.network.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami           = "ami-09eb4311cbaecf89d" //ubuntu 20.04
  instance_type = "t3.large"
  key_name      = var.key_pair_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = module.network.subnet_public-a.id
  vpc_security_group_ids = [aws_security_group.tmp.id]

  tags = {
    Name = "3-tier-bastion"
  }
}

resource "aws_instance" "web-a" {
  ami           = "ami-09eb4311cbaecf89d" //ubuntu 20.04
  instance_type = "t3.large"
  key_name      = var.key_pair_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = module.network.subnet_web-a.id
  vpc_security_group_ids = [aws_security_group.tmp.id]

  tags = {
    Name = "3-tier-web-a"
  }
}

resource "aws_instance" "web-c" {
  ami           = "ami-09eb4311cbaecf89d" //ubuntu 20.04
  instance_type = "t3.large"
  key_name      = var.key_pair_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = module.network.subnet_web-c.id
  vpc_security_group_ids = [aws_security_group.tmp.id]

  tags = {
    Name = "3-tier-web-c"
  }
}

resource "aws_instance" "was-a" {
  ami           = "ami-09eb4311cbaecf89d" //ubuntu 20.04
  instance_type = "t3.large"
  key_name      = var.key_pair_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = module.network.subnet_was-a.id
  vpc_security_group_ids = [aws_security_group.tmp.id]

  tags = {
    Name = "3-tier-was-a"
  }
}

resource "aws_instance" "was-c" {
  ami           = "ami-09eb4311cbaecf89d" //ubuntu 20.04
  instance_type = "t3.large"
  key_name      = var.key_pair_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = module.network.subnet_was-c.id
  vpc_security_group_ids = [aws_security_group.tmp.id]

  tags = {
    Name = "3-tier-was-c"
  }
}

resource "aws_instance" "db-a" {
  ami           = "ami-09eb4311cbaecf89d" //ubuntu 20.04
  instance_type = "t3.large"
  key_name      = var.key_pair_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = module.network.subnet_db-a.id
  vpc_security_group_ids = [aws_security_group.tmp.id]

  tags = {
    Name = "3-tier-db-a"
  }
}

resource "aws_instance" "db-c" {
  ami           = "ami-09eb4311cbaecf89d" //ubuntu 20.04
  instance_type = "t3.large"
  key_name      = var.key_pair_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = module.network.subnet_db-c.id
  vpc_security_group_ids = [aws_security_group.tmp.id]

  tags = {
    Name = "3-tier-db-c"
  }
}

output "bastion-ip" {
  value = aws_instance.bastion.public_ip
}

output "web-a-ip" {
  value = aws_instance.web-a.private_ip
}

output "web-c-ip" {
  value = aws_instance.web-c.private_ip
}

output "was-a-ip" {
  value = aws_instance.was-a.private_ip
}

output "was-c-ip" {
  value = aws_instance.was-c.private_ip
}

output "db-a-ip" {
  value = aws_instance.db-a.private_ip
}

output "db-c-ip" {
  value = aws_instance.db-c.private_ip
}