ARG JAVA_VERSION=21
FROM eclipse-temurin:${JAVA_VERSION}-jre

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl jq ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /server
EXPOSE 25565

# Le dépôt est monté dans /server (voir docker-compose.yml)
CMD ["./start.sh"]
