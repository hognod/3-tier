resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = "t3.large"
  key_name      = aws_key_pair.key_pair.key_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = aws_subnet.public-a.id
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "3-tier-bastion"
  }
}

resource "aws_instance" "web-a" {
  ami           = var.ami_id
  instance_type = "t3.large"
  key_name      = aws_key_pair.key_pair.key_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = aws_subnet.web-a.id
  vpc_security_group_ids = [aws_security_group.web-a.id]
  private_ip = cidrhost(aws_subnet.web-a.cidr_block, 101)

  tags = {
    Name = "3-tier-web-a"
  }
}

resource "aws_instance" "web-c" {
  ami           = var.ami_id
  instance_type = "t3.large"
  key_name      = aws_key_pair.key_pair.key_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = aws_subnet.web-c.id
  vpc_security_group_ids = [aws_security_group.web-c.id]
  private_ip = cidrhost(aws_subnet.web-c.cidr_block, 101)

  tags = {
    Name = "3-tier-web-c"
  }
}

resource "aws_instance" "was-a" {
  ami           = var.ami_id
  instance_type = "t3.large"
  key_name      = aws_key_pair.key_pair.key_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = aws_subnet.was-a.id
  vpc_security_group_ids = [aws_security_group.was-a.id]
  private_ip = cidrhost(aws_subnet.was-a.cidr_block, 101)

  tags = {
    Name = "3-tier-was-a"
  }
}

resource "aws_instance" "was-c" {
  ami           = var.ami_id
  instance_type = "t3.large"
  key_name      = aws_key_pair.key_pair.key_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = aws_subnet.was-c.id
  vpc_security_group_ids = [aws_security_group.was-c.id]
  private_ip = cidrhost(aws_subnet.was-c.cidr_block, 101)

  tags = {
    Name = "3-tier-was-c"
  }
}

resource "aws_instance" "db-a" {
  ami           = var.ami_id
  instance_type = "t3.large"
  key_name      = aws_key_pair.key_pair.key_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = aws_subnet.db-a.id
  vpc_security_group_ids = [aws_security_group.db-a.id]
  private_ip = cidrhost(aws_subnet.db-a.cidr_block, 101)

  tags = {
    Name = "3-tier-db-a"
  }
}

resource "aws_instance" "db-c" {
  ami           = var.ami_id
  instance_type = "t3.large"
  key_name      = aws_key_pair.key_pair.key_name
  
  root_block_device {
    volume_size = "20"
  }

  subnet_id = aws_subnet.db-c.id
  vpc_security_group_ids = [aws_security_group.db-c.id]
  private_ip = cidrhost(aws_subnet.db-c.cidr_block, 101)

  tags = {
    Name = "3-tier-db-c"
  }
}