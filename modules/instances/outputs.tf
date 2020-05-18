# Output data used by Bolt to do further work, doing this allows for a clean and
# abstracted interface between cloud provider implementations
output "console" {
  value       = try(aws_instance.master[0].public_ip, "")
  description = "Public IP address assigned to the Puppet Enterprise console"
}
output "compilers" {
  value       = var.architecture == "standard" ? aws_instance.master[*] : aws_instance.compiler[*] 
  description = "AWS Instance ID of the Puppet compilers"
}
