# Output data used by Bolt to do further work, doing this allows for a clean and
# abstracted interface between cloud provider implementations
output "console" {
  value       = module.instances.console
  description = "This will be the external IP address assigned to the Puppet Enterprise console"
}
output "pool" {
  value       = module.loadbalancer.lb_dns_name
  description = "The AWS loadbalancer's FQDN of the Puppet Enterprise compiler pool"
}
