# Journal de bord — Rôle A (infra, réseau, scans, Git)

Format imposé par le sujet : 2-3 lignes par étape — ce qui a été fait, ce qui a
échoué, comment cela a été corrigé. La part d'IA doit être explicitée.

| # | Horodatage | Action | Incident / échec | Correction | Part IA |
|---|---|---|---|---|---|
| 1 | JJ/MM HH:MM | Création des 2 VM Ubuntu Server 24.04 sous VirtualBox, 2 vCPU / 2 Go. | — | — | Aucune |
| 2 | | Ajout d'un 2e adaptateur host-only vboxnet0 sur chaque VM. | | | |
| 3 | | Adressage statique via netplan (.10 et .11), test `ping` croisé. | | | |
| 4 | | Installation Docker + Compose, vérification des versions. | | | |
| 5 | | Déploiement `infra/app` (Juice Shop, DVWA, PostgreSQL). | | | |
| 6 | | Génération du certificat auto-signé + déploiement `infra/front`. | | | |
| 7 | | Ouverture de l'accès Tailscale + SSH par clés pour B et C. | | | |
| 8 | | Découverte réseau `nmap -sn` sur 192.168.56.0/24. | | | |
| 9 | | Scan de services `nmap -sV -sC` sur les 2 VM → `scans/nmap/scan_helio.txt`. | | | |
| 10 | | Scan complet des ports `-p-` sur helio-app. | | | |
| 11 | | Commits progressifs et push sur le dépôt distant. | | | |

## Notes libres

_Difficultés rencontrées, hypothèses, points à rediscuter avec B et C._
