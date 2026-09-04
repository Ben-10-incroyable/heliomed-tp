#!/usr/bin/env bash
# Captures de verification exigees par le sujet (une capture par commande).
set -euo pipefail

echo "### VirtualBox";      VBoxManage --version 2>/dev/null || echo "(a lancer sur le poste hote)"
echo "### Docker";          docker --version
echo "### Docker Compose";  docker compose version
echo "### Git";             git --version
echo "### Nmap";            nmap --version | head -1
echo "### Trivy";           trivy --version 2>/dev/null | head -1 || echo "(role B)"
echo "### Conteneurs";      docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}'
echo "### Interfaces";      ip -br a
echo "### Ports en ecoute"; ss -tulpn | grep LISTEN
