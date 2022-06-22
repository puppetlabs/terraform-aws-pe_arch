variable "encrypt_disk" {
  description = "Should we encrypt the root disk"
  type        = bool
  default     = false
}
variable "disk_enc_key" {
  description = "The key to use to encrypt the disk"
  type        = string
  default     = ""
}
