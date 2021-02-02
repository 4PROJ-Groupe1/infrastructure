# infrastructure

## Prendre en main GIT

1. Initialiser un dépot git localement
```bash
$ git init
```

2. Associer votre clé ssh publique à votre compte GitHub
```sh
$ cat ~/.ssh/id_rsa.pub 
```

3. Cloner le dépot 
```git
$ git clone git@github.com:4PROJ-Groupe1/infrastructure.git
```

4. Se déplacer localement à l'intérieur du dépot
```sh
$ cd infrastructure
```

5. Créer une nouvelle branch develop
```git
$ git checkout -b develop
```

6. Créer ou modifier des fichiers localement
```sh
$ vim schema_reseau.md
```

7. Ajouter les fichiers au dépot local
```git
$ git add .
```

8. Valider les fichiers modifiés dans le référentiel git
```git
$ git commit -m "Nouveau schéma réseau"
```

9. Pousser les modifications sur la branche "develop"
```git
$ git push origin master
```

10. Pour fusionner la branche actuelle avec la branche "master"
```git
$ git merge master
```