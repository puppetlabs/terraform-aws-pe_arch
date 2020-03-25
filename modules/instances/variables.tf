# variable "id" {
#   description = "Name of GCP project that will be used for housing require infrastructure"
#   type        = string
# }
variable "user" {
  description = "Instance user name that will used for SSH operations"
  type        = string
}
variable "ssh_key" {
  description = "Location on disk of the SSH public key to be used for instance SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
variable "compiler_count" {
  description = "The quantity of compilers that are deployed behind a load balancer and will be spread across defined zones"
  type        = number
  default     = 3
}
variable id {}
variable vpc_id {}
variable subnet_ids {}
variable security_group_ids {}
variable project {}
variable architecture {}
variable instance_image {}
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
