# autoscailing launch configuration
resource "aws_launch_configuration" "custom-launch-config" {
    name = "custom-launch-config"
    image_id = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name = aws_key_pair.mykey.key_name

    # Bash script for check LB
    user_data = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet addr:172)' | awk '{ print $2 }' | cut -d ':' -f 2`\necho 'Hello Team This is my IP: '$MYIP > /var/www/html/index.html"
    lifecycle {
      create_before_destroy = true
    }
}

# autoscailing group
resource "aws_autoscaling_group" "custom-group-autoscaling" {
    name = "custom-group-autoscaling"
    vpc_zone_identifier = ["subnet-011e533363a289fff"] # subnet id ของ us-west-1b (customvpc-public-2)
    launch_configuration = aws_launch_configuration.custom-launch-config.name
    min_size = 1
    max_size = 3
    health_check_grace_period = 100
    health_check_type = "EC2"
    force_delete = true
    tag {
        key = "Name"
        value = "custom_ec2_instance"
        propagate_at_launch = true
    }
}

# autoscailing configuration policy
resource "aws_autoscaling_policy" "custom-cpu-policy" {
    name = "custom-cpu-policy"
    autoscaling_group_name = aws_autoscaling_group.custom-group-autoscaling.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = 1
    cooldown = 60
    policy_type = "SimpleScaling"
}

# cloud watch monitor
resource "aws_cloudwatch_metric_alarm" "custom-cpu-alarm" {
    alarm_name = "custom-cpu-alarm"
    alarm_description = "alarm once cpu usage increases"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = 2
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = 120
    statistic = "Average"
    threshold = 20

    dimensions = {
      "AutoScalingGroupName" : aws_autoscaling_group.custom-group-autoscaling.name
    }
    actions_enabled = true
    alarm_actions = [aws_autoscaling_policy.custom-cpu-policy.arn]
}

# auto descaling policy
resource "aws_autoscaling_policy" "custom-cpu-policy-scaledown" {
    name = "custom-cpu-policy-scaledown"
    autoscaling_group_name = aws_autoscaling_group.custom-group-autoscaling.name
    adjustment_type = "ChangeInCapacity"
    scaling_adjustment = -1
    cooldown = 60
    policy_type = "SimpleScaling"
}

# descaling cloud watch
resource "aws_cloudwatch_metric_alarm" "custom-cpu-alarm-scaledown" {
    alarm_name = "custom-cpu-alarm-scaledown"
    alarm_description = "alarm once cpu usage decreases"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = 2
    metric_name = "CPUUtilization"
    namespace = "AWS/EC2"
    period = 120
    statistic = "Average"
    threshold = 10

    dimensions = {
      "AutoScalingGroupName" : aws_autoscaling_group.custom-group-autoscaling.name
    }
    actions_enabled = true
    alarm_actions = [aws_autoscaling_policy.custom-cpu-policy-scaledown.arn]
}

