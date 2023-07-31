#Create launch template
resource "aws_launch_template" "int-pri-lt" {
  name = "int-pri-lt"
  image_id = "ami-0f000672db6d58341"
  instance_type = "t2.micro"
  key_name = "hi5-pubkp"
  user_data = filebase64("example.sh")
  vpc_security_group_ids = [aws_security_group.int1-pri-sg.id]
  
  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "int-webserver"
    }
  }
}

resource "aws_autoscaling_group" "int1-asg" {
  desired_capacity = 2
  max_size         = 3
  min_size         = 1
  vpc_zone_identifier = [aws_subnet.int1-priSN1.id, aws_subnet.int1-priSN2.id]

  launch_template {
    id      = aws_launch_template.int-pri-lt.id
    version = "$Latest"
  }
}

# scale up alarm
resource "aws_autoscaling_policy" "int1-cpu-policy" {
  name                   = "int1-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.int1-asg.id
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"

  # Policy to scale up when average CPU utilization exceeds 70%
  # target_tracking_configuration {
  #   predefined_metric_specification {
  #     predefined_metric_type = "ASGAverageCPUUtilization"
  #   }
  #   target_value = 70.0
  #   scale_in_cooldown = 300
  #   scale_out_cooldown = 300
  }

resource "aws_cloudwatch_metric_alarm" "int1-cpu-alarm" {
  alarm_name          = "int1-cpu-alarm"
  alarm_description   = "example-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.int1-asg.id
  }
  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.int1-cpu-policy.arn}"]
}

#Create launch template
resource "aws_launch_template" "int-pub-lt" {
  name = "int-pub-lt"
  image_id = "ami-0e618811ec643488b"
  instance_type = "t2.micro"
  key_name = "hi5-pubkp"
  vpc_security_group_ids = [aws_security_group.int1-pub-sg.id]

  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 8
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "public_server"
    }
  }
}

# resource "aws_launch_template" "foobar" {
#   name_prefix   = "foobar"
#   image_id      = "ami-1a2b3c"
#   instance_type = "t2.micro"
# }

resource "aws_autoscaling_group" "int1-pub-asg" {
  #availability_zones = ["us-west-1a"]
  desired_capacity = 2
  max_size         = 3
  min_size         = 2
  vpc_zone_identifier = [aws_subnet.int1-pubSN1.id, aws_subnet.int1-pubSN2.id]

  launch_template {
    id      = aws_launch_template.int-pub-lt.id
    version = "$Latest"
  }
}


