#This script is used to run the Ansible lockdown role. It scans, reports, makes corrections, scans once more, and produces a report.
#!/bin/bash
app install unzip -y
app-add-repository ppa:ansible/ansible
apt update
apt-get install ansible -y
#Ansible version should be 2.12+
ansible --version
mkdir cis-ansible;cd cis-ansible
gsutil cp gs://parjun8840-cis-ansible/ubuntu22-cis-1.3.0.zip .
unzip ubuntu22-cis-1.3.0.zip
#We need to crate a playbook to utilise the Ansible role by lockdown enterprise
cat > cis-playbook.yml <<- "EOF"
-name: CIS Benchmark
 hosts: localhost
 roles:
   - {role: ubuntu22-cis-1.3.0}
EOF
sudo ansible-playbook -l localhost cis-playbook.yml
