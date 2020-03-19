# Output data used by Bolt to do further work, doing this allows for a clean and
# abstracted interface between cloud provider implementations
output "console" {
  value       = aws_instance.master[0].public_ip
  description = "Public IP address assigned to the Puppet Enterprise console"
}
output "compilers" {
  value       = aws_instance.compiler[*].id
  description = "AWS Instance ID of the Puppet compilers"
}
