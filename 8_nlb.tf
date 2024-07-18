//Target group
resource "aws_lb_target_group" "web" {
  vpc_id = aws_vpc.main.id
  name = "3-tier-web-80"
  port = "80"
  protocol = "TCP"

  health_check {
    enabled = true
    interval = "10"
    protocol = "TCP"
  }
}

resource "aws_lb_target_group" "was" {
  vpc_id = aws_vpc.main.id
  name = "3-tier-was-8000"
  port = "8000"
  protocol = "TCP"

  health_check {
    enabled = true
    interval = "10"
    protocol = "TCP"
  }
}

resource "aws_lb_target_group" "db" {
  vpc_id = aws_vpc.main.id
  name = "3-tier-db-5432"
  port = "5432"
  protocol = "TCP"

  health_check {
    enabled = true
    interval = "10"
    protocol = "TCP"
  }
}

//Target group attachment
resource "aws_lb_target_group_attachment" "web-a" {  
  target_group_arn = aws_lb_target_group.web.arn
  target_id = aws_instance.web-a.id
  port = "80"
}

resource "aws_lb_target_group_attachment" "web-c" {  
  target_group_arn = aws_lb_target_group.web.arn
  target_id = aws_instance.web-c.id
  port = "80"
}

resource "aws_lb_target_group_attachment" "was-a" {  
  target_group_arn = aws_lb_target_group.was.arn
  target_id = aws_instance.was-a.id
  port = "8000"
}

resource "aws_lb_target_group_attachment" "was-c" {  
  target_group_arn = aws_lb_target_group.was.arn
  target_id = aws_instance.was-c.id
  port = "8000"
}

resource "aws_lb_target_group_attachment" "db-a" {  
  target_group_arn = aws_lb_target_group.db.arn
  target_id = aws_instance.db-a.id
  port = "5432"
}

resource "aws_lb_target_group_attachment" "db-c" {  
  target_group_arn = aws_lb_target_group.db.arn
  target_id = aws_instance.db-c.id
  port = "5432"
}

//LB
resource "aws_lb" "web" {  
  name = "3-tier-web-lb"
  load_balancer_type = "network"
  security_groups = [ aws_security_group.web-lb.id ]
  subnets = [
    aws_subnet.public-a.id,
    aws_subnet.public-c.id
  ]
}

resource "aws_lb" "was" {  
  name = "3-tier-was-lb"
  load_balancer_type = "network"
  internal = true
  security_groups = [ aws_security_group.was-lb.id ]
  subnets = [
    aws_subnet.was-a.id,
    aws_subnet.was-c.id
  ]
}

resource "aws_lb" "db" {  
  name = "3-tier-db-lb"
  load_balancer_type = "network"
  internal = true
  security_groups = [ aws_security_group.db-lb.id ]
  subnets = [
    aws_subnet.db-a.id,
    aws_subnet.db-c.id
  ]
}

//LB listener
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port = "80"
  protocol = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_listener" "was" {
  load_balancer_arn = aws_lb.was.arn
  port = "8000"
  protocol = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.was.arn
  }
}

resource "aws_lb_listener" "db" {
  load_balancer_arn = aws_lb.db.arn
  port = "5432"
  protocol = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.db.arn
  }
}