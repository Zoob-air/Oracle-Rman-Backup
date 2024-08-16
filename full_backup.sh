#!/bin/bash

# INPUT the VARIABEL
DB_NAME="zuber"
TYPESCRIPT="fullbackup"

BASE_BACKUP_PATH="/home/oracle/skrip/$TYPESCRIPT/$DB_NAME"

# Source the Oracle environment
. /home/oracle/db19c.env

# Get the current date
BCK=$(date "+%Y%m%d")

#set old backup
BCK_OLD=$(date -d "$BCK -1 month" +"%Y%m%d")

# Set the RMAN log path
RMAN_LOG_PATH="$BASE_BACKUP_PATH/fullbackup_log"

# Create the backup directory
mkdir -p "$BASE_BACKUP_PATH/${TYPESCRIPT}_${BCK}"
mkdir -p "$RMAN_LOG_PATH"


#Run RMAN backup script
rman target / LOG="$RMAN_LOG_PATH/backup_full_$DB_NAME_$BCK.log" <<EOF
run
{
  allocate channel ch01 type disk maxpiecesize=1024M;
  allocate channel ch02 type disk maxpiecesize=1024M;
  allocate channel ch03 type disk maxpiecesize=1024M;
  allocate channel ch04 type disk maxpiecesize=1024M;
  allocate channel ch05 type disk maxpiecesize=1024M;
  allocate channel ch06 type disk maxpiecesize=1024M;
  allocate channel ch07 type disk maxpiecesize=1024M;
  allocate channel ch08 type disk maxpiecesize=1024M;
  delete noprompt backup;
  backup as compressed backupset database format '$BASE_BACKUP_PATH/${TYPESCRIPT}_${BCK}/df_full_%T_d%d_p%p_u%u_c%c.bak';
  backup as compressed backupset current controlfile format '$BASE_BACKUP_PATH/${TYPESCRIPT}_${BCK}/cf_full_%T_d%d_p%p_u%u_c%c.ctl';
  backup as compressed backupset current controlfile for standby format '$BASE_BACKUP_PATH/${TYPESCRIPT}_${BCK}/standby_cf_full_%T_d%d_p%p_u%u_c%c.ctl';
  release channel ch01;
  release channel ch02;
  release channel ch03;
  release channel ch04;
  release channel ch05;
  release channel ch06;
  release channel ch07;
  release channel ch08;
}
EOF

#DELETE OLD BACKUP
#============================================================================================
# Copy the backup directory to the destination
#cp -r "$BASE_BACKUP_PATH/backup_full_$BCK" "/home/backup-data/rmanbackup/$DB_NAME/fullbackup"

# Remove the backup on temporary directory after successful copy
#rm -r "$BASE_BACKUP_PATH/backup_full_$BCK"
#remove old backup
#rm -r "/home/backup-data/rmanbackup/$DB_NAME/fullbackup/backup_full_$BCK_OLD"