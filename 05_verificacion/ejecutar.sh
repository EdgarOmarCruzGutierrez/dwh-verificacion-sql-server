#!/bin/bash
# Ejecuta sql/consultas_verificacion.sql contra el contenedor y escribe un CSV por consulta en resultados/.
set -e
cd "$(dirname "$0")"
CONT=sql-dwh-verificacion
PASS='SqlServer!2026'
mkdir -p resultados
awk '/^-- Q[0-9]+: /{n=$2; sub(":","",n); name=$3; f="/tmp/dwh_" n "_" name ".sql"} f{print > f}' sql/consultas_verificacion.sql
for f in /tmp/dwh_Q*.sql; do
  base=$(basename "$f" .sql); base=${base#dwh_}
  docker exec -i $CONT /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "$PASS" -C -d DataWarehouse \
    -W -s "," -b < "$f" | sed '2d' | grep -v 'rows affected' | sed '/^$/d' > "resultados/$base.csv"
  echo "resultados/$base.csv"; rm "$f"
done
