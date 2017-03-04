# Auto Manager Backup for Continuous Integration


##Backup gitlab + jenkins
```
BACKUP_MANAGER_PATH=`pwd`

docker build  -t ci-backup:s3cmd -f ${BACKUP_MANAGER_PATH}/dockerfiles/Dockerfile-s3cmd .

docker run --rm  \
--name backup \
--volume ${BACKUP_MANAGER_PATH}/miscellaneous/.s3cfg:/root/.s3cfg:ro  \
--volume ${BACKUP_MANAGER_PATH}/run/backup.sh:/backup-manager.sh:ro  \
ci-backup:s3cmd \
/backup-manager.sh
```