output "lb_dns_name" {
  value       = var.architecture == "standard" ? tolist(var.instances)[0].public_ip : try(aws_elb.pe_compiler_elb[0].dns_name, "")
  description = "The DNS name of a new Puppet Enterprise compiler LB"
}
