#!/bin/bash

DB_NAME="namadb"

# Source the Oracle environment
. /home/oracle/${DB_NAME}.env

# Get the current date
CDATE=$(date "+%Y%m%d")

# Folder base backup
BASE_BACKUP_PATH="/oracle/backup/$DB_NAME"
mkdir -p $BASE_BACKUP_PATH

# Set the RMAN log path
RMAN_LOG_PATH="$BASE_BACKUP_PATH/backup_full_$CDATE"
mkdir -p $RMAN_LOG_PATH

# Create PFILE from SPFILE using SQL*Plus
sqlplus / as sysdba <<EOF
CREATE PFILE="$RMAN_LOG_PATH/pfile_${DB_NAME}_${CDATE}.ora" FROM SPFILE;
EXIT;
EOF

# Run RMAN backup script
rman target / LOG="$RMAN_LOG_PATH/backup_full_$DB_NAME_$CDATE.log" <<EOF
run
{
    BACKUP AS BACKUPSET DATABASE FORMAT '${RMAN_LOG_PATH}/backup_%U.bkp';
    BACKUP AS BACKUPSET ARCHIVELOG ALL FORMAT '${RMAN_LOG_PATH}/arch_%U.bkp';
    BACKUP AS BACKUPSET CURRENT CONTROLFILE FORMAT '${RMAN_LOG_PATH}/controlfile_%U.bkp';
    BACKUP AS BACKUPSET SPFILE FORMAT '${RMAN_LOG_PATH}/spfile_%U.bkp';
}
EOF