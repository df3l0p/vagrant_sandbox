# Vagrant pentest

This repository hosts the vagrantfile and relevant resoures 
to bootstrap a pentest virtual machine

# Requirements

* vagrant
* ansible
* virtualbox
* virtualbox-guest-additions-iso (for guest OS installation)
* (optional) virtualbox extension. Menu available under File > Preferences > Extensions.

# Getting started

Update submodules
```bash
make update-submodule
```

Deploy vagrant pentest
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
ansible-playbook -i localhost, -c local /vagrant/res/ansible/main.yml --tags some_tags
```

## ansible

You need ansible to be installed on the host to do that.
```bash
python3 -m pip install ansible
```

You can run the playbook with
```bash
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory res/ansible/pb-dummy.yml
```
