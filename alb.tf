#Create Load Balancer Target Group
resource "aws_lb_target_group" "int1-tg" {
  name     = "int1-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.int1-vpc.id
}

#Create Load Balancer
resource "aws_lb" "int1-lb" {
  name               = "int1-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.int1-lb-sg.id]
  subnets            = [aws_subnet.int1-pubSN1.id, aws_subnet.int1-pubSN2.id]
  enable_deletion_protection = false
  
  # access_logs {
  #   bucket  = aws_s3_bucket.lb_logs.id
  #   prefix  = "test-lb"
  #   enabled = true
  # }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "alb-listener" {
    load_balancer_arn = aws_lb.int1-lb.id
    port              = "80"
    protocol          = "HTTP"
 
    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.int1-tg.id
    }
  }

# Create a new load balancer attachment
resource "aws_autoscaling_attachment" "int1-lb-attach" {
  autoscaling_group_name = aws_autoscaling_group.int1-asg.id
  # elb                    = aws_lb.int1-lb.id
  lb_target_group_arn = aws_lb_target_group.int1-tg.arn
}
