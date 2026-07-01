#!/usr/bin/env bash
set -euo pipefail

RETENTION_DAYS="${LP_RETENTION_DAYS:-3}"
DB_PATH='/app/data/store.db'

(
  while true; do
    if [[ -f "${DB_PATH}" ]]; then
      deleted=$(sqlite3 "${DB_PATH}" "
        DELETE FROM entries
        WHERE creation_time < strftime('%Y-%m-%dT%H:%M:%SZ', 'now', '-${RETENTION_DAYS} days');
        SELECT changes();
      ")
      echo "retention: deleted ${deleted} entries older than ${RETENTION_DAYS} days"
      if [[ "${deleted}" -gt 0 ]]; then
        sqlite3 "${DB_PATH}" 'VACUUM;'
        echo "retention: vacuumed database"
      fi
    fi
    sleep 3600
  done
) &

exec /app/docker-entrypoint "$@"
