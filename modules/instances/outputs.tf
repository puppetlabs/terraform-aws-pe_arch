# Output data that will be used by other submodules to build other parts of the
# stack to support defined architecture
output "console" {
  value       = coalesce(aws_instance.server[0].public_ip, aws_instance.server[0].private_ip)
  description = "This will be the external IP address assigned to the Puppet Enterprise console"
}
output "compilers" {
  value       = var.compiler_count == 0 ? aws_instance.server[*] : aws_instance.compiler[*]
  description = "Depending on architecture, either the primary master or the group of compilers created by the module for use by other modules"
}
