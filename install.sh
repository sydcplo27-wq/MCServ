#!/usr/bin/env bash
# Télécharge et installe le serveur (Fabric ou NeoForge) selon le fichier .env
set -euo pipefail
cd "$(dirname "$0")"

if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env
  set +a
fi

LOADER="${LOADER:-fabric}"
MC_VERSION="${MC_VERSION:?MC_VERSION manquant (voir .env.example)}"

case "$LOADER" in
  fabric)
    command -v jq >/dev/null || { echo "jq est requis pour Fabric (apt install jq)"; exit 1; }
    LOADER_VER="${FABRIC_LOADER_VERSION:-$(curl -fsSL https://meta.fabricmc.net/v2/versions/loader | jq -r '[.[]|select(.stable)][0].version')}"
    INSTALLER_VER="${FABRIC_INSTALLER_VERSION:-$(curl -fsSL https://meta.fabricmc.net/v2/versions/installer | jq -r '[.[]|select(.stable)][0].version')}"
    echo "Fabric: MC $MC_VERSION, loader $LOADER_VER, installer $INSTALLER_VER"
    curl -fsSL -o server.jar \
      "https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}/${LOADER_VER}/${INSTALLER_VER}/server/jar"
    ;;
  neoforge)
    NEOFORGE_VERSION="${NEOFORGE_VERSION:?NEOFORGE_VERSION manquant (voir .env.example)}"
    echo "NeoForge $NEOFORGE_VERSION (MC $MC_VERSION)"
    curl -fsSL -o neoforge-installer.jar \
      "https://maven.neoforged.net/releases/net/neoforged/neoforge/${NEOFORGE_VERSION}/neoforge-${NEOFORGE_VERSION}-installer.jar"
    java -jar neoforge-installer.jar --installServer
    rm -f neoforge-installer.jar neoforge-installer.jar.log
    ;;
  *)
    echo "LOADER inconnu: $LOADER (fabric ou neoforge)"; exit 1 ;;
esac

touch .installed
echo "Installation terminée. Lance ./start.sh"
