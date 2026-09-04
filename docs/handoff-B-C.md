# Fiche d'accès — à envoyer à B et C dès que le labo est up

## 1. Accès VPN

1. Créez un compte sur https://tailscale.com et donnez-moi votre e-mail :
   je vous partage les nœuds `helio-front` et `helio-app`.
2. Installez le client, connectez-vous, puis vérifiez : `tailscale status`.

## 2. Accès SSH

Envoyez-moi votre clé publique (`cat ~/.ssh/id_ed25519.pub`, ou générez-la avec
`ssh-keygen -t ed25519 -C "prenom-role"`). Je l'ajoute aux deux VM.

Ajoutez ensuite ceci dans votre `~/.ssh/config` (remplacez les IP Tailscale) :

```
Host helio-front
    HostName 100.x.x.x
    User helio
Host helio-app
    HostName 100.y.y.y
    User helio
```

## 3. Cibles à scanner

| Cible | URL / adresse | Pour qui |
|---|---|---|
| API HelioMed (Juice Shop) via proxy | https://192.168.56.10/ | B — ZAP scan passif |
| API HelioMed en direct | http://192.168.56.11:3000/ | B — comparaison avec/sans proxy |
| Module legacy (DVWA) | http://192.168.56.11:8080/ | B — ZAP scan passif |
| Images à scanner avec Trivy | voir `docker images` sur helio-app | B |

Le certificat HTTPS est auto-signé : dans ZAP, acceptez-le ; en curl, `-k`.

## 4. Commandes utiles pour B

```bash
# Lister les images réellement déployées (à scanner avec Trivy)
ssh helio-app 'docker ps --format "{{.Image}}"'

# Trivy depuis votre poste, sur une image distante
trivy image bkimminich/juice-shop:latest --severity HIGH,CRITICAL -f json -o trivy-juiceshop.json
```

## 5. Règle de dépôt

Toutes les sorties brutes vont dans `scans/<outil>/`, nom de fichier
`<outil>_<cible>_<AAAAMMJJ>.<ext>`. Un commit par livrable, message explicite.
