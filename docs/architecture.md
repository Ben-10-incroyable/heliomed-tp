# Architecture du labo HelioMed

## 1. Correspondance avec le périmètre du sujet

Le sujet décrit HelioMed comme une application Python (API Flask) derrière un
reverse proxy Nginx, avec une base PostgreSQL, sur deux serveurs Linux, plus une
application mobile consommant l'API. Le labo reproduit cette topologie en
remplaçant l'applicatif métier par des cibles d'entraînement reconnues :

| Composant HelioMed | Représenté par | Justification |
|---|---|---|
| Reverse proxy Nginx | Nginx 1.27 (conteneur) | Composant réel, configuré à l'identique |
| API Flask de prise de RDV | OWASP Juice Shop | Application web à API REST, vulnérabilités OWASP Top 10 documentées |
| Module legacy / back-office | DVWA | Vulnérabilités classiques (injection, XSS, upload) |
| Base de données patients | PostgreSQL 13.4 | SGBD identique au sujet ; version ancienne pour obtenir des CVE réelles avec Trivy |
| Client mobile | Requêtes HTTP directes sur l'API | Consommateur d'API hors navigateur |

## 2. Schéma logique

```
                 Internet (NAT, provisioning uniquement)
                              |
   +--------------------------+--------------------------+
   |            Reseau host-only 192.168.56.0/24          |
   |                  (reseau isole du labo)              |
   |                                                      |
   |  poste-hote .1        helio-front .10   helio-app .11
   |  (nmap, ZAP, Trivy)   +-------------+   +--------------------+
   |          ------------>| Nginx 80/443|-->| api    :3000 (JS)  |
   |                       +-------------+   | legacy :8080 (DVWA)|
   |                                         | db     :5432 (PG)  |
   |                                         +--------------------+
   |                                          reseau docker helio-back
   +------------------------------------------------------+
                              |
                    Tailscale (100.x.x.x)
                    acces distant roles B et C
```

## 3. Choix de segmentation

- Le seul chemin **prévu** vers l'applicatif est `helio-front:443` → `helio-app:3000`.
- Les ports 3000, 8080 et 5432 de `helio-app` sont néanmoins publiés sur le
  réseau labo à l'état initial : c'est le défaut de cloisonnement que
  l'exercice 1 doit **constater** (contournement du reverse proxy, base de
  données de santé joignable directement).
- L'adaptateur NAT sert uniquement au téléchargement des images et paquets. Il
  peut être désactivé après provisioning pour démontrer l'isolation
  (`VBoxManage modifyvm helio-app --nic1 null`).

## 4. Décisions à documenter dans la note d'analyse

1. Pourquoi deux VM plutôt qu'une (cloisonnement frontal / applicatif).
2. Pourquoi un réseau host-only plutôt qu'un pont (pas d'exposition au LAN domestique).
3. Pourquoi un certificat auto-signé à l'état initial, et sa limite.
4. Pourquoi des versions d'images anciennes sont volontairement retenues.
