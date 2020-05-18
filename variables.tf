variable "project" {
  description = "Name of the PE architecture project"
  type        = string
}
variable "user" {
  description = "Instance user name that will used for SSH operations"
  type        = string
  default     = "centos"
}
variable "ssh_key" {
  description = "Location on disk of the SSH public key to be used for instance SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
variable "region" {
  description = "AWS region that'll be targeted for infrastructure deployment"
  type        = string
  default     = "eu-central-1"
}
variable "compiler_count" {
  description = "The quantity of compilers that are deployed behind a load balancer and will be spread across defined zones"
  type        = number
  default     = 3

  validation {
    condition     = var.compiler_count >= 3
    error_message = "The compiler_count variable must be greater or equal to 3."
  }
}
variable "node_count" {
  description = "The quantity of nodes that are deployed within the environment for testing"
  type        = number
  default     = 0

  validation {
    condition     = length(regexall("^[[:digit:]]+.[[:digit:]]+$", tostring(var.node_count / 3))) == 0
    error_message = "The node_count variable must be divisible by 3."
  }
}
# Note that you might need to accept the AWS EULA for the AMI product used here
variable "instance_image" {
  description = "The AMI name pattern to use when deploying new cloud instances"
  type        = string
  default     = "CentOS Linux 7*ENA*"
}
variable "architecture" {
  description = "Which of the supported PE architectures modules to deploy infrastructure with"
  type        = string
  default     = "large"
}
