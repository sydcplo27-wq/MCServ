# Serveur Minecraft moddé (Java)

Modèle de dépôt pour un serveur Minecraft moddé, compatible **Fabric** et **NeoForge**.
Les binaires (server.jar, libraries…) ne sont pas versionnés : ils sont téléchargés par `install.sh`.

## Structure

| Élément | Rôle |
|---|---|
| `.env.example` | Réglages (loader, version, RAM, EULA) → à copier en `.env` |
| `install.sh` | Télécharge/installe Fabric ou NeoForge |
| `start.sh` | Lance le serveur (installe au premier démarrage) |
| `server.properties` | Configuration du serveur |
| `mods/` | Dépose ici les `.jar` de mods (versionnables ou non) |
| `config/` | Configs des mods |
| `Dockerfile`, `docker-compose.yml` | Lancement via Docker |

## Démarrage rapide (sans Docker)

Prérequis : Java 21 (MC 1.20.5+) ou 17 (MC 1.18–1.20.4), `curl`, et `jq` pour Fabric.

```bash
cp .env.example .env     # puis édite LOADER, MC_VERSION, EULA=true...
chmod +x install.sh start.sh
./start.sh
```

## Avec Docker

```bash
cp .env.example .env
docker compose up -d --build
docker attach minecraft-modded   # console (détacher : Ctrl+P puis Ctrl+Q)
```

## Ajouter des mods

1. Télécharge les mods **pour la même version de Minecraft et le même loader**.
2. Place les `.jar` dans `mods/` (Fabric : pense au *Fabric API*).
3. Redémarre le serveur.

## Notes

- Les joueurs doivent installer les mêmes mods côté client.
- Ouvre le port TCP 25565 sur ta box/pare-feu.
- Pour versionner les mods, retire `mods/*.jar` du `.gitignore` (attention à la taille et aux licences).
- Sauvegarde `world/` régulièrement (non versionné par défaut).
