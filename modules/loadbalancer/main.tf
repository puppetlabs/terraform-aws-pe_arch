resource "aws_elb" "pe_compiler_elb" {
  count         = var.architecture == "standard" ? 0 : 1
  name            = "pe-compiler-elb-${var.project}-${var.id}"
  subnets         = var.subnet_ids
  security_groups = var.security_group_ids

  dynamic "listener" {
    for_each = toset(var.ports)

    content {
      instance_port     = listener.value
      instance_protocol = "tcp"
      lb_port           = listener.value
      lb_protocol       = "tcp"
    }
  }

  # TODO This is actually not the correct healthcheck
  # The healthcheck should use the puppetserver's status endpoint
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8140"
    interval            = 30
  }

  instances                   = var.instances[*].id
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "pe_compiler_elb_${var.project}_${var.id}"
  }
}
