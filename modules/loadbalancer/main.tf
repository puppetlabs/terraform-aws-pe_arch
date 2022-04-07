locals {
  lb_count = var.has_lb ? 1 : 0
  # When using for_each to create multiple of the same resource type the value
  # set must be a set of strings, numbers toss an error
  lb_ports = toset(["8140", "8142"])
  internal = var.lb_ip_mode == "private" ? true : false
}

resource "aws_lb" "pe_compiler_service" {
  count                            = local.lb_count
  name                             = "pe-compiler-lb-${var.id}"
  internal                         = local.internal
  subnets                          = var.subnet_ids
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = true 
  idle_timeout                     = 400
}

resource "aws_lb_listener" "pe_compiler" {
  for_each          = var.has_lb ? local.lb_ports : []
  load_balancer_arn = aws_lb.pe_compiler_service[0].arn
  port              = each.value
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.pe_compiler[each.value].arn
  }
}

resource "aws_lb_target_group" "pe_compiler" {
  for_each    = var.has_lb ? local.lb_ports : []
  name        = "pe-tg-${var.id}-${each.value}"
  port        = each.value
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    port     = 8140
    protocol = "HTTPS"
    path     = "/status/v1/simple"
  }
}

# Reducing this section to one combined dynamic resource would make it hard to
# read
resource "aws_lb_target_group_attachment" "pe_compiler_8140" {
  count            = var.has_lb ? var.compiler_count : local.lb_count
  target_group_arn = aws_lb_target_group.pe_compiler["8140"].arn
  target_id        = tolist(var.instances)[count.index].id
  port             = 8140
}

resource "aws_lb_target_group_attachment" "pe_compiler_8142" {
  count            = var.has_lb ? var.compiler_count : local.lb_count
  target_group_arn = aws_lb_target_group.pe_compiler["8142"].arn
  target_id        = tolist(var.instances)[count.index].id
  port             = 8142
}