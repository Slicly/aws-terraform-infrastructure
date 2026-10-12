
# Find a current Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Launch Template
resource "aws_launch_template" "web" {
  name_prefix   = "terraform-web-"
  image_id      = var.web_ami_id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  user_data = base64encode(<<-EOF
		#!/bin/bash
		
		systemctl enable httpd
		echo "<h1>Terraform AWS Cloud Infrastructure Project</h1>" > /var/www/html/index.html
		systemctl start httpd
	EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "terraform-web-server"
      Project = "aws-terraform-infrastructure"
    }
  }
}

# Auto Scaling Group across two private subnets
resource "aws_autoscaling_group" "web" {
  name                      = "terraform-web-asg"
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300

  vpc_zone_identifier = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  target_group_arns = [
    aws_lb_target_group.web.arn
  ]

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "terraform-asg-instance"
    propagate_at_launch = true
  }
}
