resource "aws_launch_template" "lt_name" {
  name          = var.launch_template_variables.name
  image_id      = var.launch_template_variables.image_id
  instance_type = var.launch_template_variables.instance_type
  #   key_name = "client_key.pub" // 

  user_data = filebase64(var.launch_template_variables.filepath)

  vpc_security_group_ids = [aws_security_group.client_sg.id]

  tags = {
    Name = var.launch_template_variables.tagname
  }
}


resource "aws_autoscaling_group" "asg_name" {
  name                      = var.aws_autoscaling_group_variables.name
  max_size                  = var.aws_autoscaling_group_variables.min_size
  min_size                  = var.aws_autoscaling_group_variables.max_size
  desired_capacity          = var.aws_autoscaling_group_variables.desired_capacity
  health_check_grace_period = 300
  health_check_type         = var.aws_autoscaling_group_variables.health_check_type
  vpc_zone_identifier       = [aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id]
  target_group_arns         = [aws_lb_target_group.alb_target_group.arn]
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.lt_name.id
    version = aws_launch_template.lt_name.latest_version
  }


}

# scale up policy and  scale down policy 

resource "aws_autoscaling_policy" "autoscaling_policy" {
  for_each               = { for index, key in var.autoscaling_policy_variables : index => key }
  name                   = each.value.name
  adjustment_type        = each.value.adjustment_type
  scaling_adjustment     = each.value.scaling_adjustment
  cooldown               = each.value.cooldown
  policy_type            = each.value.policy_type
  autoscaling_group_name = aws_autoscaling_group.asg_name.name
}

// cloud watch alarm 

resource "aws_cloudwatch_metric_alarm" "cloud_alarm" {
  for_each = { for index, key in var.cloudwatch_variables : index => key }

  alarm_name          = each.value.alarm_name
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold
  alarm_description   = each.value.alarm_description

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg_name.name
  }

  actions_enabled = each.value.actions_enabled
  alarm_actions   = [aws_autoscaling_policy.autoscaling_policy[each.key].arn]
}

