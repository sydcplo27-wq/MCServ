#!/usr/bin/env bash
# Démarre le serveur (installe automatiquement au premier lancement)
set -euo pipefail
cd "$(dirname "$0")"

if [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  . ./.env
  set +a
fi

LOADER="${LOADER:-fabric}"
JAVA_XMX="${JAVA_XMX:-4G}"
JAVA_XMS="${JAVA_XMS:-1G}"

[ -f .installed ] || ./install.sh

if [ "${EULA:-false}" = "true" ]; then
  echo "eula=true" > eula.txt
fi
if ! grep -qs "eula=true" eula.txt; then
  echo "Tu dois accepter l'EULA Minecraft (https://aka.ms/MinecraftEULA)."
  echo "Mets EULA=true dans .env puis relance."
  exit 1
fi

# Arguments JVM (G1GC, flags Aikar simplifiés)
cat > user_jvm_args.txt <<EOF
-Xms${JAVA_XMS}
-Xmx${JAVA_XMX}
-XX:+UseG1GC
-XX:+ParallelRefProcEnabled
-XX:MaxGCPauseMillis=200
-XX:+DisableExplicitGC
-XX:+AlwaysPreTouch
EOF

case "$LOADER" in
  fabric)
    exec java @user_jvm_args.txt -jar server.jar nogui "$@"
    ;;
  neoforge)
    exec java @user_jvm_args.txt \
      "@libraries/net/neoforged/neoforge/${NEOFORGE_VERSION}/unix_args.txt" nogui "$@"
    ;;
  *)
    echo "LOADER inconnu: $LOADER"; exit 1 ;;
esac
