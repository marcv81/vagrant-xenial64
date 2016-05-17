#!/bin/bash

# Update packages list
apt-get update

# Install build tools
apt-get install -y build-essential linux-headers-`uname -r`

# Install VirtualBox Guest Additions
cd /tmp
VBOX_VERSION=5.0.18
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
mount -o loop,ro VBoxGuestAdditions_$VBOX_VERSION.iso /mnt
/mnt/VBoxLinuxAdditions.run --nox11
umount /mnt
rm VBoxGuestAdditions_$VBOX_VERSION.iso

# Install SSH server
apt-get install -y openssh-server

# Configure SSH server 
sed /etc/ssh/sshd_config -i \
	-e 's/\#AuthorizedKeysFile/AuthorizedKeysFile/g' \
	-e 's/PubKeyAuthentication no/PubKeyAuthentication yes/g' \
	-e 's/\#PubKeyAuthentication/PubKeyAuthentication/g' \
	-e 's/PermitEmptyPasswords yes/PermitEmptyPasswords no/g' \
	-e 's/\#PermitEmptyPasswords/PermitEmptyPasswords/g'
echo "UseDNS no" >> /etc/ssh/sshd_config

# Authorize Vagrant public key
mkdir -p /home/vagrant/.ssh
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub \
	-O /home/vagrant/.ssh/authorized_keys
chmod 0700 /home/vagrant/.ssh
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Allow sudo without password
echo "vagrant ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vagrant

# Set locale
echo 'LC_ALL="en_US.utf8"' >> /etc/environment

# Update Grub
sed -i /etc/default/grub \
	-e "s/GRUB_TIMEOUT=[0-9]\+/GRUB_TIMEOUT=1/g" \
	-e "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\"/GRUB_CMDLINE_LINUX_DEFAULT=\"net.ifnames=0 quiet\"/g"
update-grub

# Configure network interfaces
sed /etc/network/interfaces -i -e 's/\enp0s3/eth0/g'
echo "auto eth1" >> /etc/network/interfaces
echo "iface eth1 inet manual" >> /etc/network/interfaces
echo "auto eth2" >> /etc/network/interfaces
echo "iface eth2 inet manual" >> /etc/network/interfaces
echo "auto eth3" >> /etc/network/interfaces
echo "iface eth3 inet manual" >> /etc/network/interfaces

# Install Python 2.7
apt-get install -y python2.7
ln -s /usr/bin/python2.7 /usr/bin/python

# Optimize unused space
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
