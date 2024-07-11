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
  security_groups = [ aws_security_group.was-lb.id ]
  subnets = [
    aws_subnet.was-a.id,
    aws_subnet.was-c.id
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