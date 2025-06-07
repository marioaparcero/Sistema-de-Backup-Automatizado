#!/bin/bash
# backup.sh - Sistema de Backup Automatizado Empresarial
# Ejemplo de uso: sudo /opt/backup/backup.sh
set -e

# CONFIGURACIÓN
CONFIG_DIR="/opt/backup/config"
INCLUDE_FILE="$CONFIG_DIR/include.conf"
EXCLUDE_FILE="$CONFIG_DIR/exclude.conf"
RETENTION_DAYS=7
BACKUP_BASE="/opt/backups"
LOG_DIR="$BACKUP_BASE/logs"
DATE=$(date +%F_%H-%M-%S)
BACKUP_DIR="$BACKUP_BASE/daily/$DATE"
CHECKSUM_FILE="$BACKUP_DIR/checksums.sha256"
LOG_FILE="$LOG_DIR/backup_$DATE.log"
# REMOTE_DEST="user@remote-server:/remote/backups"
# EMAIL="admin@empresa.com"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"

# Leer rutas a respaldar
mapfile -t INCLUDE < "$INCLUDE_FILE"

# EJECUTAR RSYNC
echo "[INFO] Iniciando backup: $DATE" | tee "$LOG_FILE"
rsync -av --delete --exclude-from="$EXCLUDE_FILE" "${INCLUDE[@]}" "$BACKUP_DIR" &>> "$LOG_FILE"

# VERIFICACIÓN DE INTEGRIDAD
echo "[INFO] Calculando checksums..." | tee -a "$LOG_FILE"
find "$BACKUP_DIR" -type f -exec sha256sum {} \; > "$CHECKSUM_FILE"

# COPIA REMOTA (Opcional)
echo "[INFO] Subiendo respaldo a servidor remoto..." | tee -a "$LOG_FILE"
rsync -az "$BACKUP_DIR" "$REMOTE_DEST" &>> "$LOG_FILE"

# ROTACIÓN DE COPIAS
echo "[INFO] Ejecutando rotación (retención de $RETENTION_DAYS días)..." | tee -a "$LOG_FILE"
find "$BACKUP_BASE/daily/" -maxdepth 1 -type d -mtime +$RETENTION_DAYS -exec rm -rf {} \; >> "$LOG_FILE"

# ENVÍO DE NOTIFICACIÓN
echo "Backup completado el $DATE. Ver log adjunto." | mail -s "Backup Diario Completado" -a "$LOG_FILE" "$EMAIL"

echo "[INFO] Backup finalizado correctamente." | tee -a "$LOG_FILE"
