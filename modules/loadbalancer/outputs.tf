output "lb_dns_name" {
  value       = aws_elb.pe_compiler_elb.dns_name
  description = "The DNS name of a new Puppet Enterprise compiler LB"
}
