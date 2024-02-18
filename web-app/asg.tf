# Launch Template
resource "aws_launch_template" "web_app_lt" {
  name = "web-app-launch-template"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
    }
  }

  # Add a secondary volume for log data
  block_device_mappings {
    device_name = "/dev/xvdb"
    ebs {
      volume_size = 50
    }
  }

  image_id = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.client_alb.id]
    subnet_id                   = aws_subnet.public_subnet.0.id
  }

  #   vpc_security_group_ids = [aws_security_group.client_alb.id]

  tags = {
    Name = "${var.default_tags.project_name}-lt"
  }

}

resource "aws_autoscaling_group" "web_app_asg" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  launch_template {
    id      = aws_launch_template.web_app_lt.id
    version = aws_launch_template.web_app_lt.latest_version
  }

  tag {
    key                 = "Name"
    value               = "${var.default_tags.project_name}-asg"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}
