#!/bin/bash

# Set the base backup path
DB_NAME="infarepo"

BASE_BACKUP_PATH="/backup/ARCHIVELOG/$DB_NAME"

# Source the Oracle environment
. /home/oracle/.profilerepo

# Get the current date
BCK=$(date "+%Y%m%d")

# Create the backup directory
mkdir -p "$BASE_BACKUP_PATH/backup_archivelog_$BCK"

# Set the RMAN log path
RMAN_LOG_PATH="/home/backup-data/rmanbackup/$DB_NAME/fullbackuplogs"

# Run RMAN backup script
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
  backup as compressed backupset archivelog all delete input format '$BASE_BACKUP_PATH/backup_archivelog_$BCK/df_archive_%T_d%d_p%p_u%u_c%c.bak';
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

# Copy the backup directory to the destination
cp -r "$BASE_BACKUP_PATH/backup_archivelog_$BCK" "/home/backup-mdm/rmanbackup/$DB_NAME/archivedaily"

# Remove the backup directory after successful copy
rm -r "$BASE_BACKUP_PATH/backup_archivelog_$BCK"