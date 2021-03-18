output "lb_dns_name" {
  value       = var.has_lb ? try(aws_elb.pe_compiler_elb[0].dns_name, "") : tolist(var.instances)[0].public_dns
  description = "The DNS name of either the load balancer fronting the compiler pool or the primary master, depending on architecture"
}
