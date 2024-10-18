provider_variables = {
  "access_key_id" = ""
  "secret_key_id" = ""
  "region"        = "us-east-1"
}

vpc_variables = {
  name       = "twoTierVPC"
  cidr_block = "10.0.0.0/16"
}

// public subnets put here 

public_subnets = [
  {
    subnet_Name = "public_subnet_1a_for_NATHost"
    AZone       = "us-east-1a"
    cidr        = "10.0.1.0/24"
  },
  {
    subnet_Name = "public_subnet_1b_for_NATHost"
    AZone       = "us-east-1b"
    cidr        = "10.0.2.0/24"
  }
]

// private subnets put here 

private_subnets = [
  {
    subnet_Name = "private_subnet_1a_for_EC2"
    AZone       = "us-east-1a"
    cidr        = "10.0.3.0/24"
  },
  {
    subnet_Name = "private_subnet_1b_for_EC2"
    AZone       = "us-east-1b"
    cidr        = "10.0.4.0/24"
  },
  {
    subnet_Name = "private_subnet_1a_for_DB"
    AZone       = "us-east-1a"
    cidr        = "10.0.5.0/24"
  },
  {
    subnet_Name = "private_subnet_1b_for_DB"
    AZone       = "us-east-1b"
    cidr        = "10.0.6.0/24"
  },
]

// ==========================
// Elatic IP tags names 

tags_for_Elastic_IP = ["tags_for_Elastic_IP_a", "tags_for_Elastic_IP_b"]

// tags for NAT Gatways add inside route_tables 

tags_for_NAT_Gatways = ["Nat_Gatway_a", "Nat_Gatway_b"]


// aws security group egress rules write 
// list of port to run 80 and 443
list_of_port_to_allow_in_ingress_alb = [80, 443]


// launch tamplate variables 

launch_template_variables = {
  name          = "twotier-al-tamplate"
  image_id      = "ami-0866a3c8686eaeeba" // us-east-1 change it 
  instance_type = "t2.micro"
  tagname       = "twotier-al-tamplate"
  filepath      = "./config.sh"

}

// Autoscalling Group variables 

aws_autoscaling_group_variables = {
  name              = "twotierautoscalinggroup"
  min_size          = 2
  max_size          = 5
  desired_capacity  = 3
  health_check_type = "ELB"
}

// Auto Scaling Group policy variabls
// for scale up or down 

autoscaling_policy_variables = [{
  name               = "autoscalling_policy_for_scale_up"
  scaling_adjustment = "1"
  adjustment_type    = "ChangeInCapacity"
  cooldown           = 300
  policy_type        = "SimpleScaling"
  },
  {
    name               = "autoscalling_policy_for_scale_down"
    scaling_adjustment = "-1"
    adjustment_type    = "ChangeInCapacity"
    cooldown           = 300
    policy_type        = "SimpleScaling"
  }
]

// cloud watch alarm variables 
// aws_cloudwatch_metric_alarm scale up or down 

cloudwatch_variables = [{
  // alarm for scale up
  alarm_name          = "Scale-Up-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Autoscaling scale up alarm"
  actions_enabled     = true
  },
  {
    // alarm for scale down
    alarm_name          = "Scale-Down-alarm"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = 2
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = 120
    statistic           = "Average"
    threshold           = 5
    alarm_description   = "AutoScaling Scale Down alarm"
    actions_enabled     = true
  }
]

// rds variables 

rds_variables = {
  identifier = "bookdb-instance"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t2.micro"
    allocated_storage = 20
    username = "admin"
    password = "password"
    db_name = "dbname"
    multi_az = true 
    storage_type = "gp2"
    publicly_accessible = false
    storage_encrypted = false
    skip_final_snapshot = true 
    backup_retention_period = 0
    tagName = "db_instance"
}
