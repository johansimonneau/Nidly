# Nidly

Suivi de candidatures crèche et assistante maternelle, pour ne plus perdre le fil.

## Le problème

En France, moins d'1 enfant de moins de 3 ans sur 5 obtient une place en crèche. Trouver un
mode de garde veut souvent dire candidater à la main auprès de 10 à 30 établissements
différents (mairie, CAF, crèches privées...), chacun avec ses propres délais et son propre
système de priorité. Nidly ne crée pas de places — il aide à gérer ce chaos administratif.

## MVP v1

- Profil enfant (prénom, date de naissance/prévue, zone)
- Suivi de candidatures avec statut (à contacter, dossier envoyé, en attente, entretien,
  accepté, refusé)
- Rappels triés par échéance la plus proche (dossier, relance)
- Checklist des documents généralement demandés

Toutes les données restent **en local sur l'appareil** (Hive) — pas de backend, pas de compte,
aucune donnée familiale ne quitte le téléphone.

## Stack technique

Flutter, compilé en Flutter Web (PWA installable, hébergement gratuit) pour la v1. Le même
code pourra être compilé en app iOS/Android plus tard sans réécriture.

### Lancer le projet

```bash
flutter pub get
flutter run -d chrome   # web
flutter test
```

### Build web (PWA)

```bash
flutter build web --release
```
