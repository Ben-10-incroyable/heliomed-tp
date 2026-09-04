# Plan d'adressage et de services — labo HelioMed

> ⚠️ Ces valeurs sont celles **de votre labo**. Après le déploiement, corrigez-les
> avec vos vraies IP/ports et **utilisez exactement les mêmes** dans la note
> d'analyse, le registre d'actifs, les exports ZAP/Trivy et les logbooks.
> La cohérence entre documents est explicitement exigée par le sujet.

## Réseaux

| Réseau | Type | Plage | Rôle |
|---|---|---|---|
| NAT | VirtualBox NAT | 10.0.2.0/24 | Sortie Internet (provisioning uniquement) |
| Host-only `vboxnet0` | Réseau isolé | 192.168.56.0/24 | Réseau du labo HelioMed |
| Tailscale | VPN maillé | 100.x.x.x | Accès distant des rôles B et C |

## Machines

| Hôte | IP labo | IP Tailscale | OS | vCPU / RAM | Rôle HelioMed |
|---|---|---|---|---|---|
| poste-hote | 192.168.56.1 | à compléter | à compléter | — | Poste d'analyse (nmap, ZAP) |
| helio-front | 192.168.56.10 | à compléter | Ubuntu Server 24.04 | 2 / 2 Go | Reverse proxy Nginx |
| helio-app | 192.168.56.11 | à compléter | Ubuntu Server 24.04 | 2 / 3 Go | API + legacy + PostgreSQL |

## Services exposés (état initial, AVANT durcissement)

| Hôte | Port | Protocole | Service | Conteneur / image | Exposition voulue ? |
|---|---|---|---|---|---|
| helio-front | 22/tcp | SSH | OpenSSH | hôte | Oui (administration) |
| helio-front | 80/tcp | HTTP | Nginx | `nginx:1.27-alpine` | Oui (à rediriger en HTTPS — Ex.2) |
| helio-front | 443/tcp | HTTPS | Nginx (cert auto-signé) | `nginx:1.27-alpine` | Oui |
| helio-app | 22/tcp | SSH | OpenSSH | hôte | Oui (administration) |
| helio-app | 3000/tcp | HTTP | API HelioMed (Juice Shop) | `bkimminich/juice-shop` | **Non** — devrait être derrière le proxy |
| helio-app | 8080/tcp | HTTP | Module legacy (DVWA) | `vulnerables/web-dvwa` | **Non** |
| helio-app | 5432/tcp | PostgreSQL | Base patients | `postgres:13.4-alpine` | **Non** — exposition critique (RGPD) |

> Les trois lignes marquées « Non » sont laissées volontairement ouvertes à
> l'exercice 1 : ce sont des constats réels de l'état des lieux, qui alimentent
> le registre des vulnérabilités et seront corrigés à l'exercice 2.

## Comptes de test (labo uniquement)

| Service | Identifiant | Où est le secret |
|---|---|---|
| SSH helio-front / helio-app | `helio` | Clés publiques des 3 membres dans `~/.ssh/authorized_keys` |
| PostgreSQL | `helio_app` | `infra/app/.env` (non commité — voir `.env.example`) |
| DVWA | `admin` | Mot de passe par défaut de l'image (constat de vulnérabilité) |

## Empreintes / traçabilité

À remplir après déploiement, pour prouver la cohérence entre documents :

```bash
docker image inspect --format '{{.RepoTags}} {{.Id}}' $(docker ps -q)
sha256sum scans/nmap/*.txt
```

| Fichier / image | SHA256 | Date |
|---|---|---|
| scans/nmap/scan_helio.txt | à compléter | à compléter |
