variable "provider_variables" {
  type = object({
    access_key_id = string
    secret_key_id = string
    region        = string
  })

  default = {
    "access_key_id" = "Put Your access key id inside terraform.tfvars file"
    "secret_key_id" = "Put Your secret key id inside terraform.tfvars file"
    "region"        = "us-east-1"
  }
}

variable "vpc_variables" {
  type = object({
    name       = string
    cidr_block = string
  })

  default = {
    name       = "towtierVPC"
    cidr_block = "10.0.0.0/16"
  }
}


variable "public_subnets" {
  type = list(object({
    subnet_Name = string
    AZone       = string
    cidr        = string
  }))

  default = [{
    subnet_Name = "public_subnets"
    AZone       = "us-east-1a"
    cidr        = "10.0.1.0/24"
  }]
}

variable "private_subnets" {
  type = list(object({
    subnet_Name = string
    AZone       = string
    cidr        = string
  }))

  default = [{
    subnet_Name = "private_subnets"
    AZone       = "us-east-1b"
    cidr        = "10.0.2.0/24"
  }]
}

// Elastic IP for nat gateway 
// tags for Elastic IP 

variable "tags_for_Elastic_IP" {
  type    = list(string)
  default = ["Elastic_IP_For_a"]

}

// Tags for NAT Gateway add inside route table

variable "tags_for_NAT_Gatways" {
  type    = list(string)
  default = ["tags_for_nat_gateway"]
}


// aws security groups variables "alb_sg",

variable "list_of_port_to_allow_in_ingress_alb" {
  type    = list(number)
  default = [80]
}



/// launch tamplate variables 

variable "launch_template_variables" {
  type = object({
    name          = string
    image_id      = string
    instance_type = string
    tagname       = string
    filepath      = string
  })

  default = {
    name          = "twotier-al-tamplate"   // if write your name please use only character and hypane
    image_id      = "ami-0866a3c8686eaeeba" // this image id is belong to the us-east-1 north vergania region if you want to change to change it 
    instance_type = "t2.micro"
    tagname       = "twotier-al-tamplate"
    filepath      = "./config.sh"
  }
}


// AutoScalingGroup Variables define here 

variable "aws_autoscaling_group_variables" {
  type = object({
    name              = string
    min_size          = number
    max_size          = number
    desired_capacity  = number
    health_check_type = string
  })

  default = {
    name              = "twotierautoscalinggroup"
    min_size          = 2
    max_size          = 5
    desired_capacity  = 3
    health_check_type = "ELB"
  }
}

// Auto Scalling Group Policy Scale up or Down variables 

variable "autoscaling_policy_variables" {
  type = list(object({
    name               = string
    scaling_adjustment = string
    adjustment_type    = string
    cooldown           = number
    policy_type        = string
  }))

  default = [{
    // policy for scale up 
    name               = "autoscalling_policy_for_scale_up"
    scaling_adjustment = "1"
    adjustment_type    = "ChangeInCapacity"
    cooldown           = 300
    policy_type        = "SimpleScaling"
    },
    {
      // policy for scale down 
      name               = "autoscalling_policy_for_scale_down"
      scaling_adjustment = "-1"
      adjustment_type    = "ChangeInCapacity"
      cooldown           = 300
      policy_type        = "SimpleScaling"
  }]
}


# scale up alarm
# alarm will trigger the ASG policy (scale up /down) based on the metric (CPUUtilization), comparison_operator, threshold
//aws_cloudwatch_metric_alarm variables 

variable "cloudwatch_variables" {
  type = list(object({
    alarm_name          = string
    comparison_operator = string
    evaluation_periods  = number
    metric_name         = string
    namespace           = string
    period              = number
    statistic           = string
    threshold           = number
    alarm_description   = string
    actions_enabled     = bool
  }))

  default = [{
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
  }]
}


// rds variables 
// if you want to create a multipe db_instacnes to change variable structure like list(object({})) 
variable "rds_variables" {
  type = object({
    identifier = string
    db_name = string
    engine = string
    allocated_storage = number
    engine_version = string
    instance_class = string
    username = string
    password = string
    multi_az = bool
    storage_type = string
    storage_encrypted = bool 
    publicly_accessible = bool 
    skip_final_snapshot = bool
    backup_retention_period = number 
    tagName = string
  })



  default = {
    identifier = "value"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t2.micro"
    allocated_storage = 20
    username = "admin"
    password = "password"
    db_name = "dbname"
    multi_az = false
    storage_type = "gp2"
    publicly_accessible = false
    storage_encrypted = false
    skip_final_snapshot = false
    backup_retention_period = 0
    tagName = "value"
  }
}