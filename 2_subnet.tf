resource "aws_subnet" "public-a" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 0)
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "3-tier-public-subnet-a"
  }
}

resource "aws_subnet" "public-c" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 1)
  availability_zone = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "3-tier-public-subnet-c"
  }
}

resource "aws_subnet" "web-a" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 10)
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "3-tier-web-subnet-a"
  }
}

resource "aws_subnet" "web-c" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 11)
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "3-tier-web-subnet-c"
  }
}

resource "aws_subnet" "was-a" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 20)
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "3-tier-was-subnet-a"
  }
}

resource "aws_subnet" "was-c" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 21)
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "3-tier-was-subnet-c"
  }
}

resource "aws_subnet" "db-a" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 30)
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "3-tier-db-subnet-a"
  }
}

resource "aws_subnet" "db-c" {
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 8, 31)
  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "3-tier-db-subnet-c"
  }
}