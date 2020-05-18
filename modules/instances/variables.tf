# These are the variables required for the instances submodule to function
# properly and are duplicated highly from the main module but instead do not
# have any defaults set because this submodule should never by called from
# anything else expect the main module where values for all these variables will
# always be passed in
variable "user" {
  description = "Instance user name that will used for SSH operations"
  type        = string
}
variable "ssh_key" {
  description = "Location on disk of the SSH public key to be used for instance SSH access"
  type        = string
}
variable "compiler_count" {
  description = "The quantity of compilers that are deployed behind a load balancer and will be spread across defined zones"
  type        = number
}
variable "id" {
  description = "Randomly generated value used to produce unique names for everything to prevent collisions and visually link resources together"
  type        = string
}

variable vpc_id {}
variable subnet_ids {}
variable security_group_ids {}
variable project {}
variable architecture {}
variable instance_image {}
variable node_count {}
# The default tags are needed to prevent Puppet AWS reaper from reaping the instances
variable default_tags {
  description = "The default instance tags"
  type        = map
  default = {
    description = "PEADM Architecture"
    department  = "SA"
    project     = "peadm - autope"
    lifetime    = "1d"
    #termination_date: '2018-07-19T11:03:05.626507+00:00'
  }
}
