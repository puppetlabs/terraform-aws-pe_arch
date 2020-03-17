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
variable "private_key" {}

variable "zones" {
  description = "GCP zone that are within the defined GCP region that you wish to use"
  type        = list(string)
  default     = ["us-west1-a", "us-west1-b", "us-west1-c"]
}
variable "compiler_count" {
  description = "The quantity of compilers that are deployed behind a load balancer and will be spread across defined zones"
  type        = number
  default     = 3
}
# variable network {}
# variable subnetwork {}
variable id {}
variable vpc_id {}
variable subnet_id {}
variable security_group_ids {}
variable project {}
variable architecture {}
variable instance_image {}
variable ami_id {
  description = "The AMI id to use"
  type        = string
  default     = "ami-04cf43aca3e6f3de3"
}
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
