#!/bin/bash

path="/root/backups/database-backup"     #Path where the backup of your database "Db
nameBackup="prod-oracle"                #Environment where is hosted
mysqlUser="adibprado"                          #Your MySQL user
mysqlPass="adibinho150"                          #Your MySQL password
mysqlDatabase="canary"                      #The name of your database "Db

TIMER="$(date +'%d-%m-%Y-%H-%M')"

if [[ -z "$mysqlUser" || -z "$mysqlPass" || -z "$mysqlDatabase" ]]; then
    echo "Please fill in username, password and database in settings."
else
  # mysqldump -u$mysqlUser -p$mysqlPass $mysqlDatabase > $path"/"$nameBackup"-"$TIMER".sql" &&
    mysqldump -u$mysqlUser -p$mysqlPass $mysqlDatabase > $path"/"$nameBackup".sql" &&
    cd $path &&
    git add . &&
    git commit -m "Bkp uploaded automatically '$nameBackup'" &&
    git push &&
    echo "Backup Complete."
fi