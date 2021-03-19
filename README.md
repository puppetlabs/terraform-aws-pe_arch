# aws-pe_arch

IaC definitions for three of the supported Puppet Enterprise architectures for AWS

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with aws-pe_arch](#setup)
    * [What aws-pe_arch affects](#what-aws-pe_arch-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with aws-pe_arch](#beginning-with-aws-pe_arch)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This Terraform module implements as code the infrastructure required to deploy three permutations of the supported Puppet Enterprise architectures: Standard, Large, and Extra Large with a failover replica on Amazon Web Services. While this module can function independently, it is primarily developed as a component of puppetlabs/autope to facilitate the end-to-end deployment of fully functional stacks of Puppet Enterprise for evaluation or with additional guidance, production. It sets up native AWS networks and load balancers specifically for containing and managing access to the deployment but avoids a dependence on cloud provided SQL services since Puppet Enterprise has its own facilities for managing and automating PostgreSQL.

### Expectations and support

This Terraform module is intended to be used only by Puppet Enterprise customers actively working with and being guided by Puppet Customer Success teams—specifically, the Professional Services and Solutions Architecture teams. Independent use is not recommended for production environments without a comprehensive understanding of how Terraform works, comfort in the modification and maintenance of Terraform code, and the infrastructure requirements of a full Puppet Enterprise deployment.

This Terraform module is a services-led solution, and is **NOT** supported through Puppet Enterprise's standard or premium support.puppet.com service.

As a services-led solution, Puppet Enterprise customers who are advised to start using this module should get support for it through the following general process.

1. Be introduced to the module through a services engagement or by their Technical Account Manager (TAM).
2. During Professional Services (PS) engagements, the Puppet PS team will aid and instruct in use of the module.
3. Outside of PS engagements, use TAM services to request assistance with problems encountered when using the module, and to inform Puppet Customer Success (CS) teams of planned major maintenance or upgrades for which advisory services are needed.
4. In the absence of a TAM, your Puppet account management team (Account Executive and Solutions Engineer) may be a fallback communication option for requesting assistance, or for informing CS teams of planned major maintenance for which advisory services are needed.

This module is under active development and yet to release an initial version. There is no guarantee yet on a stable interface from commit to commit and those commits may include breaking chnages.

## Setup

### What aws-pe_arch affects

Types of things you'll be paying your cloud provider for

* Instances of various sizes
* Load balancers
* Networks

### Setup Requirements

* [AWS CLI installed](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* [AWS Credentials configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)
* [Git Installed](https://git-scm.com/downloads)
* [Terraform (>= 0.13.0) Installed](https://www.terraform.io/downloads.html)

### Beginning with aws-pe_arch

1. Clone this repository
    * `git clone https://github.com/puppetlabs/terraform-aws-pe_arch.git && cd terraform-aws-pe_arch`
2. Install module dependencies: `terraform init`
3. Initiate plan for the default standard architecture
    * `terraform apply -auto-approve -var "firewall_allow=[ \"0.0.0.0/0\" ]"`
4. Moments later you'll be presented with a single VM where to install Puppet Enterprise

## Usage

### Example: deploy large architecture with replica and a more restrictive network

This will give you the absolute minimum needed for installing Puppet Enterprise, a single VM plus a specific network for it to reside within and limited to a specific network that have access to the new infrastructure (note: internal network will always be injected into the list)

`terraform apply -auto-approve "firewall_allow=[ \"192.69.65.0/24\" ]" -var "architecture=large" -var "replica=true"`

### Example: destroy stack

The number of options required are reduced when destroying a stack

`terraform destroy -auto-approve`

## Usage notes

1. For making ssh access work with Terraform's AWS provider, you will need to add your private key corresponding to the public key in the `ssh_key` parameter to the ssh agent like so:

```bash
> eval `ssh-agent`
> ssh-add <private_key_path>
```

1. For using the configured machine images (AMIs) by the owner `679593333241`, an EULA has to be accepted once using the AWS Console.
