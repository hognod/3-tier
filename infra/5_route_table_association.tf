//////////Route Table Association
resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public-a.id
}

resource "aws_route_table_association" "public-c" {
  subnet_id      = aws_subnet.public-c.id
  route_table_id = aws_route_table.public-c.id
}

resource "aws_route_table_association" "web-a" {
  subnet_id      = aws_subnet.web-a.id
  route_table_id = aws_route_table.web-a.id
}

resource "aws_route_table_association" "web-c" {
  subnet_id      = aws_subnet.web-c.id
  route_table_id = aws_route_table.web-c.id
}

resource "aws_route_table_association" "was-a" {
  subnet_id      = aws_subnet.was-a.id
  route_table_id = aws_route_table.was-a.id
}

resource "aws_route_table_association" "was-c" {
  subnet_id      = aws_subnet.was-c.id
  route_table_id = aws_route_table.was-c.id
}

resource "aws_route_table_association" "db-a" {
  subnet_id      = aws_subnet.db-a.id
  route_table_id = aws_route_table.db-a.id
}

resource "aws_route_table_association" "db-c" {
  subnet_id      = aws_subnet.db-c.id
  route_table_id = aws_route_table.db-c.id
}