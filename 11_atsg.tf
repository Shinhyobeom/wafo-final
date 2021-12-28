resource "aws_launch_configuration" "wafo_weblacf" {
  name                 = "${var.name}-weblacf"
  image_id             = aws_ami_from_instance.ami_web.id
  instance_type        = var.ins_type
  security_groups      = [aws_security_group.sg_web.id]
  key_name             = var.key
  iam_instance_profile = "admin_role"
  user_data = file("./s3_mount.sh")
}

#배치 그룹
resource "aws_placement_group" "wafo_webpg" {
  name     = "${var.name}-webpg"
  strategy = "cluster"
}

#오토스케일링 정책
resource "aws_autoscaling_policy" "web_auto_policy" {
name                   = "${var.name}-web-auto-policy"
scaling_adjustment     = 2
adjustment_type        = "ChangeInCapacity"
cooldown               = 300
autoscaling_group_name = aws_autoscaling_group.wafo_webatsg.name
}

#오토스케일링 그룹
resource "aws_autoscaling_group" "wafo_webatsg" {
  name                      = "${var.name}-webatsg"
  min_size                  = 2
  max_size                  = 8
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = false
  #placement_group = aws_placement_group.wafo_webpg.id
  launch_configuration = aws_launch_configuration.wafo_weblacf.name
  vpc_zone_identifier  = [aws_subnet.wafo_priweb[0].id, aws_subnet.wafo_priweb[1].id]
  
  /*provisioner "local-exec" {
    command = "getips.sh"
  }*/

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "wafo_webasatt" {
  autoscaling_group_name = aws_autoscaling_group.wafo_webatsg.id
  alb_target_group_arn   = aws_lb_target_group.wafo_albtg.arn
}

resource "aws_launch_configuration" "wafo_waslacf" {
  name                 = "${var.name}-waslacf"
  image_id             = aws_ami_from_instance.ami_was.id
  instance_type        = var.ins_type_t3
  iam_instance_profile = "admin_role" #IAM 역할 만든거
  security_groups      = [aws_security_group.sg_was.id]
  key_name             = var.key
  user_data = file("./efs_mount.sh")
}

#배치 그룹
resource "aws_placement_group" "wafo_waspg" {
  name     = "${var.name}-waspg"
  strategy = "cluster"
}

#오토스케일링 정책
resource "aws_autoscaling_policy" "was_auto_policy" {
name                   = "${var.name}-was-auto-policy"
scaling_adjustment     = 4
adjustment_type        = "ChangeInCapacity"
cooldown               = 300
autoscaling_group_name = aws_autoscaling_group.wafo_wasatsg.name
}

#오토스케일링 그룹
resource "aws_autoscaling_group" "wafo_wasatsg" {
  name                      = "${var.name}-wasatsg"
  min_size                  = 2
  max_size                  = 8
  health_check_grace_period = 60
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = false
  #placement_group = aws_placement_group.wafo_waspg.id
  launch_configuration = aws_launch_configuration.wafo_waslacf.name
  vpc_zone_identifier  = [aws_subnet.wafo_priwas[0].id, aws_subnet.wafo_priwas[1].id]

  tag {
    key                 = "Name"
    value               = "was"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "wafo_wasasatt" {
  autoscaling_group_name = aws_autoscaling_group.wafo_wasatsg.id
  alb_target_group_arn   = aws_lb_target_group.wafo_nlbtg.arn
}



