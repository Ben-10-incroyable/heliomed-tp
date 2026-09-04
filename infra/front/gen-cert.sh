#!/usr/bin/env bash
# Genere le certificat auto-signe du reverse proxy HelioMed.
# Le certificat et la cle ne sont pas commites (voir .gitignore).
set -euo pipefail

CERT_DIR="$(dirname "$0")/nginx/certs"
mkdir -p "$CERT_DIR"

openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
  -keyout "$CERT_DIR/heliomed.key" \
  -out    "$CERT_DIR/heliomed.crt" \
  -subj "/C=FR/O=HelioMed/CN=heliomed.lab" \
  -addext "subjectAltName=DNS:heliomed.lab,IP:192.168.56.10"

chmod 600 "$CERT_DIR/heliomed.key"

echo "Certificat genere :"
openssl x509 -in "$CERT_DIR/heliomed.crt" -noout -subject -dates -fingerprint -sha256
