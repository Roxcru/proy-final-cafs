#!/bin/bash

set -euo pipefail

TIMESTAMP=$(TZ="${BACKUP_TIMEZONE:-America/Lima}" date '+%Y%m%d%H%M%S')

BACKUP_FILE="/tmp/${DB_NAME}_${TIMESTAMP}.sql.gz"

S3_PATH="s3://${S3_BUCKET}/${S3_PREFIX}/${TIMESTAMP}/${DB_NAME}_${TIMESTAMP}.sql.gz"

echo "=========================================="
echo "INICIANDO BACKUP"
echo "=========================================="
echo "Base de datos : ${DB_NAME}"
echo "Servidor      : ${DB_HOST}"
echo "Puerto        : ${DB_PORT}"
echo "Fecha         : ${TIMESTAMP}"
echo "Destino       : ${S3_PATH}"
echo "=========================================="

echo "Generando dump de MySQL..."

export MYSQL_PWD="${DB_PASSWORD}"

mariadb-dump \
    --host="${DB_HOST}" \
    --port="${DB_PORT}" \
    --user="${DB_USER}" \
    --single-transaction \
    --routines \
    --triggers \
    "${DB_NAME}" | gzip > "${BACKUP_FILE}"

unset MYSQL_PWD

echo "Backup generado: ${BACKUP_FILE}"

echo "Subiendo backup a S3..."

aws s3 cp \
    "${BACKUP_FILE}" \
    "${S3_PATH}"

echo "Backup subido correctamente."

rm -f "${BACKUP_FILE}"

echo "=========================================="
echo "BACKUP FINALIZADO"
echo "=========================================="