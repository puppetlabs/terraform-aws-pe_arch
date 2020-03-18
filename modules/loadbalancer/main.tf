resource "aws_elb" "pe_compiler_elb" {
  name            = "pe-compiler-elb-${var.project}-${var.id}"
  subnets         = [var.subnet_id]
  security_groups = var.security_group_ids

  listener {
    instance_port     = 8140
    instance_protocol = "http"
    lb_port           = 8140
    lb_protocol       = "http"
  }

  listener {
    instance_port     = 8142
    instance_protocol = "http"
    lb_port           = 8142
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:8140"
    interval            = 30
  }

  instances                   = var.instances
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "pe_compiler_elb_${var.project}_${var.id}"
  }
}
/*
resource "google_compute_instance_group" "backend" {
  for_each = toset(var.zones)
  name     = "pe-compiler-${var.id}"

  instances = [for i in var.instances : i.self_link if i.zone == each.value]
  zone      = each.value
}

resource "google_compute_health_check" "pe_compiler" {
  name = "pe-compiler-${var.id}"

  tcp_health_check { port = var.ports[0] }
}

resource "google_compute_region_backend_service" "pe_compiler_lb" {
  name          = "pe-compiler-lb-${var.id}"
  health_checks = [google_compute_health_check.pe_compiler.self_link]
  region        = var.region

  dynamic "backend" {
    for_each = toset(var.zones)

    content { group = google_compute_instance_group.backend[backend.value].self_link }
  }
}

resource "google_compute_forwarding_rule" "pe_compiler_lb" {
  name                  = "pe-compiler-lb-${var.id}"
  service_label         = "puppet"
  load_balancing_scheme = "INTERNAL"
  ports                 = var.ports
  network               = var.network
  subnetwork            = var.subnetwork
  backend_service       = google_compute_region_backend_service.pe_compiler_lb.self_link
}
*/
