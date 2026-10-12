# Automatically adjust EC2 capacity based on CPU usage
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "terraform-cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"

  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

# CloudWatch alarm for sustained high CPU utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "terraform-web-high-cpu"
  alarm_description   = "Alert when ASG average CPU exceeds 70%"
  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2
  period             = 300
  threshold          = 70

  metric_name = "CPUUtilization"
  namespace   = "AWS/EC2"
  statistic   = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  treat_missing_data = "missing"

  tags = {
    Name = "terraform-high-cpu-alarm"
  }
}
