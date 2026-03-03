# 1. ALB కోసం కొత్త సెక్యూరిటీ గ్రూప్ (ఇంటర్నెట్ నుండి ట్రాఫిక్ తీసుకోవడానికి)
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  vpc_id      = aws_vpc.prod_vpc.id # ఇక్కడ 'prod_vpc' అని మార్చాను

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = "fintech-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  
  # ఇక్కడ మీ పబ్లిక్ సబ్‌నెట్స్ ఇండెక్స్ వాడాను
  subnets            = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id] 

  tags = {
    Name = "App-ALB"
  }
}

# 3. Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.prod_vpc.id # ఇక్కడ కూడా 'prod_vpc'

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# 4. Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# 5. Target Group Attachment (మీ రెండు యాప్ సర్వర్లను యాడ్ చేయడం)
resource "aws_lb_target_group_attachment" "app_attach_1" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server[0].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "app_attach_2" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server[1].id
  port             = 80
}
