#!/bin/bash

basename=$(basename $0);
basedir=$( which $0 |  sed "s/\/$basename//g");

jenkins_name=$(date +%F_%Hh%M)-Jenkins.tgz

#Variables you can change
#------------------------
path_tmp=/root/temp
aws_bucket_name=ci-backups
#------------------------

[ ! -d $path_tmp ] && mkdir $path_tmp

/bin/tar -czf ${path_tmp}/${jenkins_name} --exclude=/home/jenkins/docker_jenkins_home/workspace /home/jenkins/docker_jenkins_home

/usr/bin/docker run --rm  \
--name backup \
--volume ${basedir}/miscellaneous/.s3cfg:/root/.s3cfg:ro  \
--volume ${path_tmp}:/backup  \
ci-backup:s3cmd \
put /backup/${jenkins_name} s3://${aws_bucket_name}/


/usr/bin/docker exec -t ci-gitlab gitlab-rake  gitlab:backup:create

/usr/bin/docker run --rm  \
--name backup \
--volume ${basedir}/.s3cfg:/root/.s3cfg:ro  \
--volume /home/git/gitlab_data/backups:/backup  \
ci-backup:s3cmd \
put --recursive /backup/ s3://${aws_bucket_name}/


/bin/rm ${path_tmp}/${jenkins_name}
/bin/rm /home/git/gitlab_data/backups/*