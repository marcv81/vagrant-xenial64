# Intro

This project creates an Ubuntu 16.04.1 LTS 64-bit Vagrant box which is ready to provision with Ansible.

# Setup

Create a VirtualBox VM. Use the defaults except for the following.

- Name: xenial64
- 512Mb RAM
- 40Gb VMDK

Install Ubuntu 16.04.1 LTS 64-bits. Use the defaults except for the following.

- User: vagrant
- Password: vagrant

Log in and run the following.

    sudo -i
    wget -O - http://bit.ly/2dANLtM | bash
    history -c
    init 0

On the host run the following.

    vagrant package --base xenial64
    vagrant box add marcv81/xenial64 package.box
