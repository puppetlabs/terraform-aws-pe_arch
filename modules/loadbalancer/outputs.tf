output "lb_dns_name" {
  value       = var.has_lb ? try(aws_lb.pe_compiler_service[0].dns_name, "") : coalesce(tolist(var.instances)[0].public_dns, tolist(var.instances)[0].private_dns)
  description = "The DNS name of either the load balancer fronting the compiler pool or the primary master, depending on architecture"
}
