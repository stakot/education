#!/bin/bash
terraform init && terraform apply -auto-approve && cd ./ansible/ && ansible-playbook -i ./ec2.py --limit "tag_Name_web" site.yml