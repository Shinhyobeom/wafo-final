resource "aws_lb" "wafo_alb" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = var.lb_type_app
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = [aws_subnet.wafo_pub[0].id,aws_subnet.wafo_pub[1].id]
  access_logs {
        bucket = aws_s3_bucket.wafo_log_bucket.bucket
        enabled = true
    }
  tags = {
    "Name" = "${var.name}-alb"
  }
}

resource "aws_lb_target_group" "wafo_albtg" {
  name        = "${var.name}-albtg"
  port        = var.port_web
  protocol    = var.HTTP
  target_type = var.lb_tg_type
  vpc_id      = aws_vpc.wafo_vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 5
    matcher             = "200"
    path                = "/health.html"
    port                = "traffic-port"
    protocol            = var.HTTP
    timeout             = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "wafo_alblis" {
  load_balancer_arn = aws_lb.wafo_alb.arn
  port              = "80"
  protocol          = var.HTTP

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wafo_albtg.arn
  }
}

data "aws_elb_service_account" "wafo_elb_account" {}

output "alb_dns_name" {
  value = aws_lb.wafo_alb.dns_name
}
