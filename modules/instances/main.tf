# This datasource will produce the most recent AMI
# with the name pattern as provided in var.instance_image
# and owner as specified.
# To use AMIs by this owner, an EULA has to be acccepted once
# using the AWS Console.
data "aws_ami" "centos7" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.instance_image]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"] # How to look up AMI owner ID?
}

resource "aws_key_pair" "pe_adm" {
  key_name   = "pe_adm_${var.project}"
  public_key = file(var.ssh_key)
}

# Instances to run PE Master
resource "aws_instance" "master" {
  ami                    = data.aws_ami.centos7.id
  instance_type          = "t3.xlarge"
  count                  = var.architecture == "xlarge" ? 2 : 1
  key_name               = aws_key_pair.pe_adm.key_name
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = var.security_group_ids
  tags                   = merge(var.default_tags, map("Name", "pe-master-${var.project}-${count.index}-${var.id}"))

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Using remote-execs on each instance deployment to ensure things are really
  # really up before doing to the next step, helps with Bolt plans that'll
  # immediately connect then fail
  # NOTE: you will need to add your private key corresponding to `ssh_key` 
  # to the ssh agent like so:
  # $ eval `ssh-agent`
  # $ ssh-add
  provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = var.user
    }
    inline = ["# Connected"]
  }
}

# Instances to run PE PSQL
resource "aws_instance" "psql" {
  ami                    = data.aws_ami.centos7.id
  instance_type          = "t3.2xlarge"
  count                  = var.architecture == "xlarge" ? 2 : 0
  key_name               = aws_key_pair.pe_adm.key_name
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = var.security_group_ids
  tags                   = merge(var.default_tags, map("Name", "pe-psql-${var.project}-${count.index}-${var.id}"))

  root_block_device {
    volume_size = 100
    volume_type = "gp2"
  }

  # Using remote-execs on each instance deployment to ensure things are really
  # really up before doing to the next step, helps with Bolt plans that'll
  # immediately connect then fail
  # NOTE: you will need to add your private key corresponding to `ssh_key` 
  # to the ssh agent like so:
  # $ eval `ssh-agent`
  # $ ssh-add
  provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = var.user
    }
    inline = ["# Connected"]
  }

}

# Instances to run a compilers
resource "aws_instance" "compiler" {
  ami                    = data.aws_ami.centos7.id
  instance_type          = "t3.xlarge"
  count                  = var.compiler_count
  key_name               = aws_key_pair.pe_adm.key_name
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = var.security_group_ids
  tags                   = merge(var.default_tags, map("Name", "pe-compiler-${var.project}-${count.index}-${var.id}"))
  # vpc_security_group_ids = list()
  # zone          = element(var.zones, count.index)

  # Old style internal DNS easiest until Bolt inventory dynamic
  # metadata = {
  #   "sshKeys"      = "${var.user}:${file(var.ssh_key)}"
  #   "VmDnsSetting" = "ZonalPreferred"
  #   "internalDNS"  = "pe-compiler-${var.id}-${count.index}.${element(var.zones, count.index)}.c.${var.project}.internal"
  # }

  root_block_device {
    volume_size = 15
    volume_type = "gp2"
  }

  # Using remote-execs on each instance deployment to ensure things are really
  # really up before doing to the next step, helps with Bolt plans that'll
  # immediately connect then fail
  # NOTE: you will need to add your private key corresponding to `ssh_key` 
  # to the ssh agent like so:
  # $ eval `ssh-agent`
  # $ ssh-add
  provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = var.user
    }
    inline = ["# Connected"]
  }

}
