# Retrophora Server

Prototype de serveur indépendant en Kotlin/Ktor. Première étape : route `/v1/health` et schéma PostgreSQL initial, **sans système de comptes fonctionnel**.

## Développement

JDK 21, Gradle récent, PostgreSQL pour les migrations futures.

```sh
gradle test
gradle run
curl http://127.0.0.1:8080/v1/health
```

La migration `db/migrations/V001__baseline.sql` est une proposition et n'est pas appliquée automatiquement. Ne pas exposer publiquement cette première version.

Licence : AGPL-3.0-only.