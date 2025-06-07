#!/bin/bash
# restore.sh - Restauración de respaldos
# Ejemplo de uso: sudo /opt/backup/restore.sh 2025-06-07_16-30-32 /home/usuario/restaurado

set -e

# CONFIGURACIÓN
BACKUP_BASE="/opt/backups/daily"
DEST_DIR="/opt/restore"

if [ -z "$1" ]; then
  echo "Uso: $0 <fecha_backup> [directorio_destino]"
  echo "Ejemplo: $0 2025-06-07_16-30-32 /home/usuario/restaurado"
  exit 1
fi

BACKUP_DATE="$1"
RESTORE_FROM="$BACKUP_BASE/$BACKUP_DATE"

if [ ! -d "$RESTORE_FROM" ]; then
  echo "[ERROR] No se encontró el respaldo en: $RESTORE_FROM"
  exit 2
fi

if [ -n "$2" ]; then
  DEST_DIR="$2"
fi

mkdir -p "$DEST_DIR"
echo "[INFO] Restaurando desde $RESTORE_FROM hacia $DEST_DIR..."

rsync -av "$RESTORE_FROM/" "$DEST_DIR/"

# VERIFICACIÓN POST-RESTAURACIÓN
if [ -f "$RESTORE_FROM/checksums.sha256" ]; then
  echo "[INFO] Verificando integridad con checksums..."
  (cd "$DEST_DIR" && sha256sum -c "$RESTORE_FROM/checksums.sha256")
else
  echo "[ADVERTENCIA] No se encontró archivo de verificación: checksums.sha256"
fi

echo "[INFO] Restauración finalizada."
exit 0
