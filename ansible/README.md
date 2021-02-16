README
=========

Prérequis
------------

Listes des packages à installer sur l'ensemble des serveurs :

* ansible
* sshpass

_Un compte avec les droits administrateurs ou sudo._


Commandes utiles
------------------

Déploiement des utilisateurs : 
```sh 
ansible-playbook --user max --become -k -K -i inventories/production.ini playbooks/users.yml
```