resource "aws_lb" "wafo_nlb" {
  name               = "${var.name}-nlb"
  internal           = true
  load_balancer_type = var.lb_type_net
  subnets            = [aws_subnet.wafo_priweb[0].id,aws_subnet.wafo_priweb[1].id]
}

resource "aws_lb_target_group" "wafo_nlbtg" {
  name        = "${var.name}-nlbtg"
  port        = var.port_was
  protocol    = var.pro_tcp
  target_type = "instance"
  vpc_id      = aws_vpc.wafo_vpc.id
}

resource "aws_lb_listener" "wafo_nlblis" {
  load_balancer_arn = aws_lb.wafo_nlb.arn
  port              = "8080"
  protocol          = var.pro_tcp

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wafo_nlbtg.arn
  }
}

output "nlb_dns_name" {
  value = aws_lb.wafo_nlb.dns_name
}