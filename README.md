# Auto Manager Backup for Continuous Integration


##Backup gitlab + jenkins
```
BACKUP_MANAGER_PATH=`pwd`

docker build  -t ci-backup:s3cmd -f ${BACKUP_MANAGER_PATH}/dockerfiles/Dockerfile-s3cmd .

${BACKUP_MANAGER_PATH}/backup.sh

```