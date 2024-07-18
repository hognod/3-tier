//lb
resource "aws_security_group" "web-lb" {
  name = "3-tier-web-lb"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [
      aws_subnet.web-a.cidr_block,
      aws_subnet.web-c.cidr_block
    ]
  }

  tags = {
    Name = "3-tier-web-lb"
  }
}

resource "aws_security_group" "was-lb" {
  name = "3-tier-was-lb"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "TCP"
    cidr_blocks = [
      aws_subnet.web-a.cidr_block,
      aws_subnet.web-c.cidr_block
    ]
  }

  egress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "TCP"
    cidr_blocks = [
      aws_subnet.was-a.cidr_block,
      aws_subnet.was-c.cidr_block
    ]
  }

  tags = {
    Name = "3-tier-was-lb"
  }
}

resource "aws_security_group" "db-lb" {
  name = "3-tier-db-lb"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = [
      aws_subnet.was-a.cidr_block,
      aws_subnet.was-c.cidr_block
    ]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    cidr_blocks = [
      aws_subnet.db-a.cidr_block,
      aws_subnet.db-c.cidr_block
    ]
  }

  tags = {
    Name = "3-tier-db-lb"
  }
}

//instance
resource "aws_security_group" "bastion" {
  name = "3-tier-bastion"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = [
      aws_subnet.web-a.cidr_block,
      aws_subnet.web-c.cidr_block,
      aws_subnet.was-a.cidr_block,
      aws_subnet.was-c.cidr_block,
      aws_subnet.db-a.cidr_block,
      aws_subnet.db-c.cidr_block
    ]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "3-tier-bastion"
  }
}

resource "aws_security_group" "web-a" {
  name = "3-tier-web-a"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    security_groups = [aws_security_group.web-lb.id]
  }

  egress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "TCP"
    security_groups = [aws_security_group.was-lb.id]
  }

  tags = {
    Name = "3-tier-web-a"
  }
}

resource "aws_security_group" "web-c" {
  name = "3-tier-web-c"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    security_groups = [aws_security_group.web-lb.id]
  }

  egress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "TCP"
    security_groups = [aws_security_group.was-lb.id]
  }

  tags = {
    Name = "3-tier-web-c"
  }
}

resource "aws_security_group" "was-a" {
  name = "3-tier-was-a"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "TCP"
    security_groups = [aws_security_group.was-lb.id]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    security_groups = [aws_security_group.db-lb.id]
  }

  tags = {
    Name = "3-tier-was-a"
  }
}

resource "aws_security_group" "was-c" {
  name = "3-tier-was-c"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "TCP"
    security_groups = [aws_security_group.was-lb.id]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    security_groups = [aws_security_group.db-lb.id]
  }

  tags = {
    Name = "3-tier-was-c"
  }
}

resource "aws_security_group" "db-a" {
  name = "3-tier-db-a"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    security_groups = [aws_security_group.db-lb.id]
  }

  tags = {
    Name = "3-tier-db-a"
  }
}

resource "aws_security_group" "db-c" {
  name = "3-tier-db-c"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "TCP"
    security_groups = [aws_security_group.db-lb.id]
  }

  tags = {
    Name = "3-tier-db-c"
  }
}