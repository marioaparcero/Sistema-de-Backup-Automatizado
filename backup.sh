#!/bin/bash
# backup.sh - Sistema de Backup Automatizado Empresarial

set -e

# ==== CONFIGURACIÓN ====
CONFIG_DIR="/opt/backup/config"
INCLUDE_FILE="$CONFIG_DIR/include.conf"
EXCLUDE_FILE="$CONFIG_DIR/exclude.conf"
RETENTION_DAYS=7
BACKUP_BASE="/opt/backups"
LOG_DIR="$BACKUP_BASE/logs"
DATE=$(date +%F_%H-%M-%S)
BACKUP_DIR="$BACKUP_BASE/daily/$DATE"
LOG_FILE="$LOG_DIR/backup_$DATE.log"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

# Leer rutas a respaldar
mapfile -t INCLUDE < "$INCLUDE_FILE"

# ==== EJECUTAR RSYNC ====
echo "[INFO] Iniciando backup: $DATE" | tee "$LOG_FILE"
rsync -av --delete --exclude-from="$EXCLUDE_FILE" "${INCLUDE[@]}" "$BACKUP_DIR" &>> "$LOG_FILE"

# ==== ROTACIÓN DE COPIAS ====
echo "[INFO] Ejecutando rotación (retención de $RETENTION_DAYS días)..." | tee -a "$LOG_FILE"
find "$BACKUP_BASE/daily/" -maxdepth 1 -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \; >> "$LOG_FILE"

echo "[INFO] Backup finalizado correctamente." | tee -a "$LOG_FILE"
