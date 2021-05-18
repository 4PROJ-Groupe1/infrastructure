ansible-playbook --user root -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml
ansible-playbook --user root -i inventory/mycluster/hosts.yaml --private-key /root/.ssh/id_rsa cluster.yml
