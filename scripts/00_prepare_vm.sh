#!/usr/bin/env bash
# Preparation d'une VM du labo HelioMed (Ubuntu Server 24.04 / Debian 12).
# Usage : sudo ./00_prepare_vm.sh helio-front   ou   sudo ./00_prepare_vm.sh helio-app
set -euo pipefail

HOSTNAME_CIBLE="${1:?Usage: $0 <helio-front|helio-app>}"

echo "== 1. Nom d'hote =="
hostnamectl set-hostname "$HOSTNAME_CIBLE"

echo "== 2. Mise a jour =="
apt-get update -qq
apt-get install -y ca-certificates curl git openssh-server

echo "== 3. Resolution locale du labo =="
grep -q helio-front /etc/hosts || cat >> /etc/hosts <<'HOSTS'
192.168.56.10   helio-front heliomed.lab
192.168.56.11   helio-app
HOSTS

echo "== 4. Docker Engine + Compose =="
if ! command -v docker >/dev/null 2>&1; then
    curl -fsSL https://get.docker.com | sh
fi
usermod -aG docker "${SUDO_USER:-$USER}"

echo "== 5. Verifications (a capturer) =="
docker --version
docker compose version
git --version
ip -br a

echo
echo "Terminé. Deconnectez/reconnectez la session pour que le groupe docker prenne effet."
