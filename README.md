packer-graylog2
===============

This repo contains [packer](http://www.packer.io) templates to build machine images with puppet for [graylog2](http://graylog2.org).


Preperation
------------

You have to install the following software:
[packer](http://www.packer.io)
[librarian-puppet](https://github.com/rodjek/librarian-puppet)

```bash
wget https://dl.bintray.com/mitchellh/packer/0.6.1_linux_amd64.zip
sudo unzip -d /usr/local/packer 0.6.1_linux_amd64.zip
export PATH=$PATH:/usr/local/packer
```

```bash
sudo gem install librarian-puppet --no-ri --no-rdoc
```

Install required puppet modules:

```bash
cd puppet
librarian-puppet install
```


Usage
-----

At the moment just the `amazon-ebs` builder is supported.

To build an `amazon-ebs` AMI run packer:

```bash
cd packer
packer build \
    -var 'aws_access_key=Lala' \
    -var 'aws_secret_key=Lulu' \
    -var 'aws_instance_type=m1.small' \
    aws-ebs-trusty-puppet.json
```

Now you have to wait! Packer will bake a fresh machine image for you. 
After that, create a new security group and allow following ports: tcp 80/443, udp 12201
Launch an EC2 instance with created AMI and security group.

Open your browser go to https://$PublicIP and login with admin/admin

See puppet/manifests/site.pp and https://github.com/synyx/puppet-graylog2 for custom configuration options.

Default values for aws-ebs-trusty-puppet.json:

```bash
packer inspect aws-ebs-trusty-puppet.json
Optional variables and their defaults:

  aws_access_key    = 
  aws_ami_name      = graylog2_trusty_x86_64-{{timestamp}}
  aws_instance_type = t1.micro
  aws_region        = eu-west-1
  aws_secret_key    = 
  aws_source_ami    = ami-41bf6c36
  ssh_username      = ubuntu

Builders:

  amazon-ebs

Provisioners:

  shell
  puppet-masterless

Note: If your build names contain user variables or template
functions such as 'timestamp', these are processed at build time,
and therefore only show in their raw form here.

```


License
-------

packer-graylog2 is released under the MIT License. See the bundled LICENSE file for details.

