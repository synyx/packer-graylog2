#!/bin/bash

sudo apt-get update
sudo apt-get install -y wget
wget https://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb
rm -f puppetlabs-release-trusty.deb
sudo apt-get update
sudo apt-get install -y puppet
