# Sistema de Backup Automatizado Empresarial

Este proyecto proporciona una solución de respaldo empresarial totalmente automatizada con verificación de integridad, rotación de copias antiguas, copia remota y restauración ante desastres.

## Características

* Copias de seguridad automáticas usando `rsync`
* Inclusión y exclusión de rutas configurables
* Verificación de integridad mediante `sha256sum`
* Rotación automática de backups antiguos según días configurados
* Envío de notificaciones por email con log adjunto
* Soporte para copia remota a servidor externo
* Script de restauración con verificación post-recuperación

---

## Estructura del Proyecto

```
/opt/
├── backup/
│   ├── config/
│   │   ├── include.conf     # Rutas a incluir en el backup
│   │   └── exclude.conf     # Rutas a excluir del backup
│   ├── backup.sh            # Script principal de backup
│   └── restore.sh           # Script de restauración
└── backups/
    ├── daily/               # Carpeta donde se almacenan los backups
    └── logs/                # Carpeta de logs de respaldo
```

---

## Requisitos

* `bash`
* `rsync`
* `sha256sum`
* `mail` (opcional, para notificaciones)
* Acceso SSH si se utiliza copia remota

---

## Configuración

### Archivos de configuración

* **include.conf**: Rutas absolutas a respaldar (una por línea)

  ```
  /etc
  /home
  /var/www
  ```

* **exclude.conf**: Rutas a excluir del backup (relativas a las incluidas)

  ```
  *.log
  *.tmp
  /home/usuario/Descargas
  ```

### Variables editables en `backup.sh`

* `RETENTION_DAYS`: Días de retención antes de borrar backups antiguos
* `BACKUP_BASE`: Ruta base para almacenar los backups
* `REMOTE_DEST`: Ruta remota para enviar los respaldos
* `EMAIL`: Correo destinatario para notificaciones

---

## Uso

### 1. Ejecutar el Backup

```bash
sudo /opt/backup/backup.sh
```

### 2. Restaurar un Backup

```bash
sudo /opt/backup/restore.sh <fecha_backup> [directorio_destino]
```

**Ejemplo:**

```bash
sudo /opt/backup/restore.sh 2025-07-05_16-30-00 /home/usuario/restaurado
```

---

## Seguridad y Buenas Prácticas

* El script debe ejecutarse como root para acceder a todos los directorios.
* Se recomienda usar discos separados o almacenamiento externo para los backups.
* Usar claves SSH para la copia remota.
* Comprobar regularmente los logs de respaldo.
* Probar periódicamente la restauración.

---

## Ideas para Mejoras Futuras

* Compresión automática de los backups (`tar + gzip`)
* Cifrado GPG antes del envío remoto
* Soporte para bases de datos (MySQL/PostgreSQL)
* Interfaz web de gestión

---

## Licencia

Este proyecto está licenciado bajo la MIT License. Puedes usarlo y modificarlo libremente.
