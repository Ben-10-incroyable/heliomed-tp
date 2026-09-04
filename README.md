# HelioMed — TP Cybersécurité & protection des données

Dépôt du laboratoire isolé HelioMed (PME, plateforme de prise de RDV médicaux).
Périmètre commun aux 5 exercices du TP.

## Équipe

| Rôle | Membre | Périmètre |
|---|---|---|
| A | Ruben | Infra, VM, Docker, réseau, nmap, dépôt Git |
| B | Etiaine | Sécurité applicative : OWASP ZAP, Trivy |
| C | Evan | Analyse : registre d'actifs, STRIDE, matrice de risque, EBIOS RM |

## Architecture du labo

Deux VM Linux sur un réseau host-only isolé `192.168.56.0/24` :

- `helio-front` (192.168.56.10) — reverse proxy Nginx, seul point d'entrée web
- `helio-app`   (192.168.56.11) — API applicative + module legacy + PostgreSQL

Voir `docs/architecture.md` et `docs/plan-adressage.md`.

## Arborescence

```
docs/          notes d'architecture, plan d'adressage, logbooks
infra/front/   docker-compose + configuration Nginx de la VM frontale
infra/app/     docker-compose + init BDD de la VM applicative
scripts/       scripts de préparation et de scan
scans/         sorties brutes des outils (nmap, ZAP, Trivy)
captures/      captures d'écran de vérification (versions, scans, etc.)
```

## Démarrage rapide

```bash
# Sur helio-app
cd infra/app && cp .env.example .env && $EDITOR .env && docker compose up -d

# Sur helio-front
cd infra/front && ./gen-cert.sh && docker compose up -d

# Depuis le poste hôte (192.168.56.1)
./scripts/10_scan_nmap.sh
```

## Avertissement

Environnement volontairement vulnérable (OWASP Juice Shop, DVWA), à usage
pédagogique uniquement, sur un réseau isolé sans exposition Internet entrante.
Aucune donnée personnelle réelle : le jeu de données patients est fictif.
