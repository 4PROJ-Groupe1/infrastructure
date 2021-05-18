# MongoDB

### Backup

En ssh depuis la VM.

Dump:
```sh
mongodump --uri "mongodb://my-user:Supinf0@example-mongodb-svc.mongo.svc.cluster.local:27017/?replicaSet=example-mongodb" --archive=dump/$(date +"%Y_%m_%d_%I_%M_%p").date.gz --gzip
```

Restore (attention à l'archive à restorer):
```sh
mongorestore --uri "mongodb://my-user:Supinf0@example-mongodb-svc.mongo.svc.cluster.local:27017/?replicaSet=example-mongodb" --archive=dump/MyArchive --gzip
```
