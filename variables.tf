variable "project" {
  description = "The name of the PE deployment project to tag resources with"
  type        = string
  default     = "pecdm"
}
variable "user" {
  description = "Default instance user name that will used for SSH operations"
  type        = string
  default     = "ec2-user"
}
variable "ssh_key" {
  description = "Location on disk of the SSH public key to be used for instance SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
variable "region" {
  description = "AWS region that'll be targeted for infrastructure deployment"
  type        = string
  default     = "us-west-2"
}
variable "compiler_count" {
  description = "The quantity of compilers that are provisioned behind a load balancer"
  type        = number
  default     = 1
}
variable "node_count" {
  description = "The quantity of nodes that are deployed within the environment for testing"
  type        = number
  default     = 0
}
# If you provision from Marketplace then you might need to accept the AWS EULA
# for the AMI product used, default comes directly from AlmaLinux and no
# additional steps are required
variable "instance_image" {
  description = "The AMI name pattern to use when deploying new cloud instances"
  type        = string
  default     = "764336703387/AlmaLinux OS 8*"
}
variable "tags" {
  description = "A map of tags to apply to provisioned resources"
  type        = map
  default     = {}
}
variable "architecture" {
  description = "Which of the supported PE architectures modules to provision infrastructure for"
  type        = string
  default     = "large"
}
variable "firewall_allow" {
  description = "List of permitted IP addresses, all entries must be provided in CIDR Subnet Mask Notation"
  type        = list(string)
  default     = []
}
variable "replica" {
  description = "To provision instances required for the deploying a primary server replica"
  type        = bool
  default     = false
}
variable "cluster_profile" {
  description = "Which cluster profile to use for defining provisioned instance sizes"
  type        = string
  default     = "development"

  validation {
    condition     = contains(["production", "development", "user"], var.cluster_profile)
    error_message = "The cluster profile selection must match one of production, development, or user."
  }
}
variable "subnet" {
  description = "An optional list of subnets to use"
  type        = list(string)
  default     = null
}
variable "lb_ip_mode" {
  description = "Designate if a public or private IP address is assigned to load balancer"
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.lb_ip_mode)
    error_message = "The provisioned load balancer can only have a public or private IP address assigned."
  }
}
variable "disable_lb" {
  description = "Disable load balancer creation for all architectures if you desire manually provisioning your own"
  type        = bool
  default     = false
}
variable "domain_name" {
  description = "Custom domain to use for internalDNS"
  type        = string
  default     = null
}