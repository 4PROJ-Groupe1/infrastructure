# README

## Prérequis

* Listes des packages à installer sur l'ensemble des serveurs :
    * ansible
    * sshpass
* Un compte avec les droits administrateurs ou sudo.
* Génération de pair de clé ssh et copy vers le lot de serveur.

## Génération de la pair de clé ssh

1. Génération de la clé ssh : `ssh-keygen -R 4096`
2. Copie de la clé publique vers les serveurs : `ssh-copy-id max@10.0.20.xxx`

## Commandes utiles

Déploiement des utilisateurs :
```bash
ansible-playbook --user max --become -k -K -i inventories/production.ini playbooks/users.yml
```

Déploiement et approvisionnement de docker, kubernetes et des dossiers utilisateurs :
```bash
ansible-playbook --user max --become -k -K -i inventories/production.ini playbooks/installationDockerK8s.yml
```