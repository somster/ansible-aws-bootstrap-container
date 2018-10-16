#!/bin/bash

echo "Begining of the ansible task"

# Continue installation of the application

echo "running installation $APP"
 ansible-playbook playbooks/$APP/spinEC2.yml
 /tmp/ansible/ec2.py --refresh-cache
 ansible-playbook playbooks/$APP/install.yml
echo "running migration $APP"
ansible-playbook playbooks/migration/$APP/migration.yml
