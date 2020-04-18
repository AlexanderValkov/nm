resource "aws_autoscaling_policy" "ecs_asg_out" {
  name                   = "ecs_asg_out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 120
  autoscaling_group_name = aws_autoscaling_group.ecs.name
}


resource "aws_cloudwatch_metric_alarm" "ClusterMemoryResevationHigh" {
  alarm_name                = "nmMemoryReservationHigh"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "MemoryReservation"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 Memory Reservation"
  insufficient_data_actions = []
  dimensions = {
    ClusterName = "nm"
  }
  alarm_actions             = [aws_autoscaling_policy.ecs_asg_out.arn]
}


resource "aws_cloudwatch_metric_alarm" "ClusterCPUReservationHigh" {
  alarm_name                = "nmCPUReservationHigh"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUReservation"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 CPU Reservation"
  insufficient_data_actions = []
  dimensions = {
    ClusterName = "nm"
  }
  alarm_actions             = [aws_autoscaling_policy.ecs_asg_out.arn]
}


resource "aws_autoscaling_policy" "ecs_asg_in" {
  name                   = "ecs_asg_in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 120
  autoscaling_group_name = aws_autoscaling_group.ecs.name
}


resource "aws_cloudwatch_metric_alarm" "ClusterMemoryResevationLow" {
  alarm_name                = "nmMemoryReservationLow"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "MemoryReservation"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "40"
  alarm_description         = "This metric monitors ec2 Memory Reservation"
  insufficient_data_actions = []
  dimensions = {
    ClusterName = "nm"
  }
  alarm_actions             = [aws_autoscaling_policy.ecs_asg_in.arn]
}


resource "aws_cloudwatch_metric_alarm" "ClusterCPUReservationLow" {
  alarm_name                = "nmCPUReservationLow"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUReservation"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "40"
  alarm_description         = "This metric monitors ec2 CPU Reservation"
  insufficient_data_actions = []
  dimensions = {
    ClusterName = "nm"
  }
  alarm_actions             = [aws_autoscaling_policy.ecs_asg_in.arn]
}
