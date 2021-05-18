#!/bin/bash
date_backup=$(date +"%Y_%m_%d_%I_%M_%p")
mongodump --uri "mongodb://my-user:Supinf0@example-mongodb-svc.mongo.svc.cluster.local:27017/?replicaSet=example-mongodb" --out=/home/max/backup/mongo/$date_backup
cd /home/max/backup/mongo/
tar -cvzf - $date_backup | gpg --batch -c --passphrase LWFFLSB4EywSQTY7mtYC > mongo_backup_$date_backup.tar.gz.gpg
rm -rf /home/max/backup/mongo/$date_backup
scp -i ~/.ssh/id_rsa -P 2152 /home/max/backup/mongo/mongo_backup_$date_backup.tar.gz.gpg root@5.196.70.106:/root/mongo/.
