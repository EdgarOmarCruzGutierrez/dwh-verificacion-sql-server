#!/bin/zsh
# Haz doble clic en este archivo en Mac. Inicia SQL Server en Docker para el proyecto de Data Warehouse.
# Dentro de SQL Server, este paquete queda en C:\sql\dwh_project\ (SQL Server en Linux lee C:\ como /), así que los scripts se ejecutan como en los videos.
CONTAINER="sql-dwh-project"
PKG="dwh_project"
PASSWORD="SqlServer!2026"
cd "$(dirname "$0")"
PKG_DIR="$(cd ../.. && pwd)"
PATH="/Applications/Docker.app/Contents/Resources/bin:/usr/local/bin:$PATH"
pause() { echo; read -k 1 -s "?Presiona cualquier tecla para cerrar."; echo; }

if ! docker info >/dev/null 2>&1; then
  echo "Docker Desktop no está en ejecución. Inicia Docker Desktop, espera a que aparezca el ícono de la ballena y vuelve a hacer doble clic en este archivo."
  pause; exit 1
fi

# Basta un SQL Server: si otro paquete ya inició uno en el puerto 1433, se usa ese.
TARGET="$(docker ps --filter publish=1433 --format '{{.Names}}' | head -1)"
if [ -z "$TARGET" ]; then
  echo "Iniciando SQL Server (el primer inicio lo descarga, unos 1.5 GB) ..."
  docker compose up -d || { pause; exit 1; }
  TARGET="$CONTAINER"
else
  echo "SQL Server ya se está ejecutando en Docker ($TARGET). Se usará ese."
fi

sql() { docker exec "$TARGET" /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$PASSWORD" -C -h -1 -Q "$1" 2>/dev/null; }
printf "Esperando a SQL Server "
for i in {1..120}; do sql "SELECT 1" >/dev/null && break; printf "."; sleep 2; done; echo
if ! sql "SELECT 1" >/dev/null; then
  echo "SQL Server no respondió. Abre Docker Desktop, haz clic en el contenedor $TARGET y lee su registro. La causa habitual: Rosetta está desactivado (sección Mac: Docker de la guía)."
  pause; exit 1
fi

# Colocar los archivos del paquete donde los buscan los scripts.
docker exec -u root "$TARGET" mkdir -p "/sql/$PKG"
docker cp "$PKG_DIR/01_datasets" "$TARGET:/sql/$PKG/" 2>/dev/null || for d in "$PKG_DIR/01_datasets"; do docker cp "$d" "$TARGET:/sql/$PKG/"; done
docker exec -u root "$TARGET" chown -R mssql:root /sql

print -r -- 'Listo. Los datasets están donde los buscan los scripts: C:\sql\dwh_project\01_datasets\'
echo "Ejecuta primero 03_scripts/init_database.sql y luego construye el warehouse como en el proyecto."
echo "Conéctate en Visual Studio Code: servidor localhost, puerto 1433, usuario sa, contraseña $PASSWORD"
pause
