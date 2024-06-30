output "vpc" {
  value = aws_vpc.main
}

output "subnet_public-a" {
  value = aws_subnet.public-a
}

output "subnet_public-c" {
  value = aws_subnet.public-c
}

output "subnet_web-a" {
  value = aws_subnet.web-a
}

output "subnet_web-c" {
  value = aws_subnet.web-c
}

output "subnet_was-a" {
  value = aws_subnet.was-a
}

output "subnet_was-c" {
  value = aws_subnet.was-c
}

output "subnet_db-a" {
  value = aws_subnet.db-a
}

output "subnet_db-c" {
  value = aws_subnet.db-c
}