# Task Manager Dart

Application de gestion de tâches en ligne de commande développée en Dart.

## Fonctionnalités

- Ajouter une tâche
- Définir une priorité : low, medium ou high
- Ajouter une date limite optionnelle
- Lister les tâches
- Trier les tâches par priorité ou par date
- Marquer une tâche comme terminée
- Supprimer une tâche
- Sauvegarder les tâches dans un fichier JSON
- Gérer les erreurs avec des exceptions personnalisées

## Structure

- `bin/task_manager.dart` : application CLI
- `lib/task.dart` : modèle Task, héritage et exceptions
- `lib/repository.dart` : interface générique Repository
- `lib/task_repository.dart` : gestion et sauvegarde JSON
- `test/task_test.dart` : tests unitaires

## Lancer l'application

Dans le terminal :

```bash
dart run bin/task_manager.dart