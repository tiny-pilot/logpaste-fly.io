#!/usr/bin/env bash
set -euo pipefail

RETENTION_DAYS="${LP_RETENTION_DAYS:-3}"
DB_PATH='/app/data/store.db'
INTERVAL_SECONDS="${LP_CLEANUP_INTERVAL_SECONDS:-3600}"

cleanup_loop() {
  # Wait for Litestream to restore the DB before first cleanup.
  sleep 120

  while true; do
    if [[ -f "${DB_PATH}" ]]; then
      deleted=$(sqlite3 "${DB_PATH}" "
        PRAGMA busy_timeout = 300000;
        DELETE FROM entries
        WHERE creation_time < strftime('%Y-%m-%dT%H:%M:%SZ', 'now', '-${RETENTION_DAYS} days');
        SELECT changes();
      " 2>&1) || true

      if [[ "${deleted}" =~ ^[0-9]+$ ]]; then
        echo "retention: deleted ${deleted} entries older than ${RETENTION_DAYS} days"
        if [[ "${deleted}" -gt 0 ]]; then
          sqlite3 "${DB_PATH}" 'PRAGMA busy_timeout = 300000; VACUUM;' 2>&1 || echo "retention: vacuum failed, will retry next cycle"
          echo "retention: vacuumed database"
        fi
      else
        echo "retention: cleanup failed: ${deleted}"
      fi
    else
      echo "retention: database not found, skipping"
    fi
    sleep "${INTERVAL_SECONDS}"
  done
}

cleanup_loop &

exec /app/docker-entrypoint "$@"
