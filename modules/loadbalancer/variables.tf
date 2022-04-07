# These are the variables required for the loadbalancer submodule to function
# properly and are duplicated highly from the main module but instead do not
# have any defaults set because this submodule should never by called from
# anything else expect the main module where values for all these variables will
# always be passed i
variable ports {
    description = "A list of ports that will be load balanced"
    type        = list(string)
}
variable "region" {
  description = "AWS region that'll be targeted for infrastructure deployment"
  type        = string
}
variable instances {
    description = "Instance resource objects that are to be added to the newly set up load balancers"
    type        = set(any)
}
variable "id" {
  description = "Randomly generated value used to produce unique names for everything"
  type        = string
}
variable "has_lb" {
  description = "A boolean that indicates if the deployment requires load balancer deployment"
  type        = bool
}
variable "compiler_count" {
  description = "The quantity of compilers that are deployed behind a load balancer"
  type        = number 
}
variable subnet_ids {
    description = "AWS subnet ids that are provided by the networking module"
}
variable security_group_ids {
    description = "AWS security groups ids that are provided by the networking module"
}
variable project {
  description = "The name of the PE deployment project to tag resources with"
}
variable "vpc_id" {
  description = "Randomly generated value used to produce unique names for everything"
}
variable "lb_ip_mode" {
  description = "Designate if a public or private IP address is assigned to load balancer"
  type        = string
}