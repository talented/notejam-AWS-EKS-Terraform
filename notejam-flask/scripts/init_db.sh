#!/usr/bin/env sh
set -Eeo pipefail
# echo "local all all all trust" >> /var/lib/postgresql/data/pg_hba.conf
echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf