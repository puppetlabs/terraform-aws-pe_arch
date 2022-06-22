resource "aws_instance" "server" {
  root_block_device {
    volume_size = var.primary_disk
    volume_type = "gp2"
    encrypted   = var.encrypt_disk
    kms_key_id  = var.encrypt_disk ? var.disk_enc_key : ""
  }
}

resource "aws_instance" "psql" {
  root_block_device {
    volume_size = var.database_disk
    volume_type = "gp2"
    encrypted   = var.encrypt_disk
    kms_key_id  = var.encrypt_disk ? var.disk_enc_key : ""
  }
}

resource "aws_instance" "compiler" {
  root_block_device {
    volume_size = var.compiler_disk
    volume_type = "gp2"
    encrypted   = var.encrypt_disk
    kms_key_id  = var.encrypt_disk ? var.disk_enc_key : ""
  }
}

resource "aws_instance" "node" {
  root_block_device {
    volume_size = 15
    volume_type = "gp2"
    encrypted   = var.encrypt_disk
    kms_key_id  = var.encrypt_disk ? var.disk_enc_key : ""
  }
}
