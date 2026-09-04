#!/usr/bin/env bash
# Campagne de decouverte reseau du labo HelioMed (exercice 1, etape 1.1).
# A lancer depuis une machine du labo (poste hote 192.168.56.1) avec sudo.
set -euo pipefail

PLAGE="${1:-192.168.56.0/24}"
CIBLES="${2:-192.168.56.10,192.168.56.11}"
OUT="$(dirname "$0")/../scans/nmap"
DATE="$(date +%Y%m%d-%H%M)"
mkdir -p "$OUT"

echo "== 1. Decouverte d'hotes sur $PLAGE =="
nmap -sn "$PLAGE" -oA "$OUT/decouverte_$DATE"

echo "== 2. Services et versions (scan de reference du sujet) =="
nmap -sV -sC "$CIBLES" -oN "$OUT/scan_helio.txt" -oX "$OUT/scan_helio.xml"

echo "== 3. Balayage complet des 65535 ports TCP =="
nmap -sS -p- --min-rate 1000 "$CIBLES" -oA "$OUT/ports_complets_$DATE"

echo "== 4. Principaux ports UDP =="
nmap -sU --top-ports 20 "$CIBLES" -oA "$OUT/udp_$DATE"

echo "== 5. Scripts d'audit ciblés =="
nmap -p 443 --script ssl-enum-ciphers,ssl-cert 192.168.56.10 -oN "$OUT/tls_front_$DATE.txt"
nmap -p 5432 --script pgsql-brute --script-args pgsql-brute.nothreads=1 192.168.56.11 \
     -oN "$OUT/pgsql_$DATE.txt" || true

echo
echo "== 6. Empreintes des sorties (traçabilite) =="
sha256sum "$OUT"/*.txt "$OUT"/*.xml | tee "$OUT/SHA256SUMS_$DATE.txt"

echo
echo "Sorties disponibles dans $OUT"
