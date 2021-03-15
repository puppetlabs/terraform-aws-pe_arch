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
variable "server_count" {
  description = "The quantity of nodes that are deployed within the environment for testing"
  type        = number
}
variable "database_count" {
  description = "The quantity of nodes that are deployed within the environment for testing"
  type        = number
}
variable "id" {
  description = "Randomly generated value used to produce unique names for everything to prevent collisions and visually link resources together"
  type        = string
}
variable "vpc_id" {
  description = "ID of VPC network provisioned by the networking submodule"
}
variable "subnet_ids" {
  description = "List of zonal subnet IDs provisioned by the networking submodule"
}
variable "security_group_ids" {
  description = "List of SG IDs provisioned by the networking submodule"
}
variable "project" {
  description = "Name of project that will be used for cosmetically linking resources together"
  type        = string
}
variable "instance_image" {
  description = "The disk image to use when deploying new cloud instances"
  type        = string
}
variable "node_count" {
  description = "The quantity of nodes that are deployed within the environment for testing"
  type        = number
}
# The default tags are needed to prevent Puppet AWS reaper from reaping the instances
variable default_tags {
  description = "The default instance tags"
  type        = map
  default = {
    description = "PEADM Architecture"
    department  = "SA"
    project     = "peadm - autope"
    lifetime    = "1d"
  }
}
