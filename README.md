# Vagrant sandbox

This repository hosts the vagrantfile and relevant resoures 
to bootstrap a sandbox virtual machine

# Requirements

* vagrant
* ansible
* virtualbox
* virtualbox-guest-additions-iso for guest OS installation. On linux it should be under `/usr/share/virtualbox/VBoxGuestAdditions.iso`
* (optional) virtualbox extension pack. Menu available under File > Preferences > Extensions.

# Getting started

Deploy vagrant sandbox
```bash
vagrant up
```

To login: vagrant / vagrant

# Running ansible playbooks manually

Depending on the ansible provider, you can run playbooks manually for troubleshooting them

## ansible_local

Connect to your instance with `vagrant ssh` and execute the following
```bash
ansible -i localhost -m ping
ansible-playbook -i localhost, -c local /path/to/share/res/ansible/main.yml --tags some_tags
# if use `vagrant ssh` and you get an error related to encoding issues, use:
# export LC_ALL=C.UTF-8
```

## ansible

You need ansible to be installed on the host to do that.
```bash
python3 -m pip install --break-system-packages ansible
```

You can run the playbook with
```bash
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory res/ansible/pb-dummy.yml
```
