# aws-pe_arch

IaC definitions for three of the supported Puppet Enterprise architectures for AWS

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with google-pe_arch](#setup)
    * [What google-pe_arch affects](#what-google-pe_arch-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with google-pe_arch](#beginning-with-google-pe_arch)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This Terraform module implements as code the infrastructure required to deploy three permutations of the [supported](https://puppet.com/docs/pe/latest/choosing_an_architecture.html) Puppet Enterprise architectures: Standard, Large, and Extra Large with a failover replica on AWS. While this module can function independently, it is primarily developed as a component of [puppetlabs/autope](https://github.com/puppetlabs/puppetlabs-autope) to facilitate the end-to-end deployment of fully functional stacks of Puppet Enterprise for evaluation or with additional guidance, production. It sets an AWS VPC and load balancers specifically for containing and managing access to the deployment but avoids a dependence on cloud provided SQL services since Puppet Enterprise has its own facilities for managing and automating PostgreSQL.

## Setup

### What aws-pe_arch affects

Types of things you'll be paying your cloud provider for

* Instances of various sizes
* Load balancers

### Setup Requirements

* [AWS CLI installed](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* [AWS Credentials configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
* [Git Installed](https://git-scm.com/downloads)
* [Terraform (>= 0.12.20) Installed](https://www.terraform.io/downloads.html)

### Beginning with aws-pe_arch

1. Clone this repository
    * `git clone https://github.com/puppetlabs/terraform-aws-pe_arch.git && cd terraform-aws-pe_arch`
2. Install module dependencies: `terraform init`
3. Initiate plan for the default Extra Large with replica
    * `terraform apply -auto-approve -var "project=myproject" -var "firewall_allow=[ \"0.0.0.0/0\" ]"`
4. Approximately 5 minutes later you'll have 7 VMs live and wired into an appropriate load balancer

## Usage

### Example: deploy standard architecture with a more restrictive network

This will give you the absolute minimum needed for installing Puppet Enterprise, a single VM plus a specific network for it to reside within and limited to a specific network that have access to the new infrastructure (note: internal network will always be injected into the list)

`terraform apply -auto-approve -var "project=myproject" -var "firewall_allow=[ \"192.69.65.0/24\" ]" -var architecture=standard`

### Example: destroy stack

The number of options required are reduced when destroying a stack

`terraform destroy -auto-approve -var "project=myproject"`

## Limitations

Currently limited to CentOS and VM disk sizes are not configurable

## Usage notes

1. For making ssh access work with Terraform's AWS provider, you will need to add your private key corresponding to the public key in the `ssh_key` parameter to the ssh agent like so:

```bash
> eval `ssh-agent`
> ssh-add <private_key_path>
```

1. For using the configured machine images (AMIs) by the owner `679593333241`, an EULA has to be accepted once using the AWS Console.