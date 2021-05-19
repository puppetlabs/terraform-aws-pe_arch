# This data source will produce the most recent AMI with the name pattern as
# provided in var.instance_image and owner as specified.
#
# To use AMIs by this owner, an EULA has to be accepted once using the AWS
# Console.
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

# In both large and standard we only require a single Primary but under a
# standard architecture the instance will also serve catalogs as a Compiler in
# addition to hosting all other core services. 
resource "aws_instance" "server" {
  ami                    = data.aws_ami.centos7.id
  instance_type          = "t3.xlarge"
  count                  = var.server_count
  key_name               = aws_key_pair.pe_adm.key_name
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = var.security_group_ids
  tags                   = merge(var.default_tags, tomap({Name = "pe-server-${var.project}-${count.index}-${var.id}"}))

  root_block_device {
    volume_size = 50
    volume_type = "gp2"
  }

  # Using remote-execs on each instance deployment to ensure things are really
  # really up before doing to the next step, helps with Bolt plans that'll
  # immediately connect then fail
  #
  # NOTE: you will need to add your private key corresponding to `ssh_key` 
  # to the ssh agent like so:
  # $ eval $(ssh-agent)
  # $ ssh-add
  provisioner "remote-exec" {
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.user
    }
    inline = ["# Connected"]
  }
}

# The biggest infrastructure difference to account for between large and extra
# large is externalization of the database service. Again given out assumption
# that extra large currently also means "with replica", we deploy two identical
# hosts in extra large but nothing in the other two architectures
resource "aws_instance" "psql" {
  ami                    = data.aws_ami.centos7.id
  instance_type          = "t3.2xlarge"
  # count is used to effectively "no-op" this resource in the event that we
  # deploy any architecture other than xlarge
  count                  = var.database_count
  key_name               = aws_key_pair.pe_adm.key_name
  subnet_id              = var.subnet_ids[count.index]
  vpc_security_group_ids = var.security_group_ids
  tags                   = merge(var.default_tags, tomap({Name = "pe-psql-${var.project}-${count.index}-${var.id}"}))

  root_block_device {
    volume_size = 100
    volume_type = "gp2"
  }

  # Using remote-execs on each instance deployment to ensure things are really
  # really up before doing to the next step, helps with Bolt plans that'll
  # immediately connect then fail
  #
  # NOTE: you will need to add your private key corresponding to `ssh_key` 
  # to the ssh agent like so:
  # $ eval $(ssh-agent)
  # $ ssh-add
  provisioner "remote-exec" {
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.user
    }
    inline = ["# Connected"]
  }
}

# The defining difference between standard and other architectures is the
# presence of load balanced instances with the sole duty of compiling catalogs
# for agents. A user chosen number of Compilers will be deployed in large and
# extra large but only ever zero can be deployed when the operating mode is set
# to standard
resource "aws_instance" "compiler" {
  ami                    = data.aws_ami.centos7.id
  instance_type          = "t3.xlarge"
  # count is used to effectively "no-op" this resource in the event that we
  # deploy the standard architecture
  count                  = var.compiler_count
  key_name               = aws_key_pair.pe_adm.key_name
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = var.security_group_ids
  tags                   = merge(var.default_tags, tomap({Name = "pe-compiler-${var.project}-${count.index}-${var.id}"}))

  root_block_device {
    volume_size = 15
    volume_type = "gp2"
  }

  # Using remote-execs on each instance deployment to ensure things are really
  # really up before doing to the next step, helps with Bolt plans that'll
  # immediately connect then fail
  #
  # NOTE: you will need to add your private key corresponding to `ssh_key` 
  # to the ssh agent like so:
  # $ eval `ssh-agent`
  # $ ssh-add
  provisioner "remote-exec" {
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.user
    }
    inline = ["# Connected"]
  }
}

# User requested number of nodes to serve as agent nodes for when this module is
# used to standup Puppet Enterprise for test and evaluation
resource "aws_instance" "node" {
  ami                    = data.aws_ami.centos7.id
  instance_type          = "t3.small"
  count                  = var.node_count
  key_name               = aws_key_pair.pe_adm.key_name
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = var.security_group_ids
  tags                   = merge(var.default_tags, tomap({Name = "pe-node-${var.project}-${count.index}-${var.id}"}))

  root_block_device {
    volume_size = 15
    volume_type = "gp2"
  }

  # Using remote-execs on each instance deployment to ensure things are really
  # really up before doing to the next step, helps with Bolt plans that'll
  # immediately connect then fail
  #
  # NOTE: you will need to add your private key corresponding to `ssh_key` 
  # to the ssh agent like so:
  # $ eval `ssh-agent`
  # $ ssh-add
  provisioner "remote-exec" {
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = var.user
    }
    inline = ["# Connected"]
  }
}
