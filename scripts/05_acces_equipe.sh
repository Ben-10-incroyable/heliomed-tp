#!/usr/bin/env bash
# Ouvre l'acces du labo aux roles B et C : Tailscale + cles SSH.
# A executer sur helio-front ET sur helio-app.
set -euo pipefail

echo "== 1. Tailscale =="
if ! command -v tailscale >/dev/null 2>&1; then
    curl -fsSL https://tailscale.com/install.sh | sh
fi
sudo tailscale up --ssh
tailscale status
tailscale ip -4

echo
echo "== 2. Cles publiques de B et C =="
echo "Collez les cles publiques recues (une par ligne), puis Ctrl-D :"
mkdir -p ~/.ssh && chmod 700 ~/.ssh
cat >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo "Cles enregistrees :"
ssh-keygen -lf ~/.ssh/authorized_keys

echo
echo "== 3. Durcissement minimal SSH =="
echo "Verifiez /etc/ssh/sshd_config : PasswordAuthentication no, PermitRootLogin no"
echo "puis : sudo systemctl restart ssh"
