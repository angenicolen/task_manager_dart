import 'dart:io';

import 'package:task_manager_dart/task.dart';
import 'package:task_manager_dart/task_repository.dart';

void main() {
  final repository = TaskRepository('tasks.json');

  repository.load();

  print('================================');
  print('       TASK MANAGER CLI');
  print('================================');

  while (true) {
    print('\n1. Ajouter une tâche');
    print('2. Lister les tâches');
    print('3. Marquer une tâche comme terminée');
    print('4. Supprimer une tâche');
    print('5. Quitter');

    stdout.write('\nVotre choix : ');
    final choice = stdin.readLineSync();

    try {
      switch (choice) {
        case '1':
          addTask(repository);
          break;

        case '2':
          listTasks(repository);
          break;

        case '3':
          completeTask(repository);
          break;

        case '4':
          deleteTask(repository);
          break;

        case '5':
          print('\nAu revoir !');
          return;

        default:
          print('\nChoix invalide.');
      }
    } on TaskException catch (e) {
      print('\nErreur : ${e.message}');
    } catch (e) {
      print('\nErreur inattendue : $e');
    }
  }
}

void addTask(TaskRepository repository) {
  stdout.write('\nTitre : ');
  final title = stdin.readLineSync()?.trim() ?? '';

  if (title.isEmpty) {
    throw InvalidTaskException('Le titre ne peut pas être vide.');
  }

  stdout.write('Priorité (low/medium/high) : ');
  final priorityInput =
      stdin.readLineSync()?.trim().toLowerCase() ?? '';

  final priority = parsePriority(priorityInput);

  stdout.write('Date limite (YYYY-MM-DD, optionnelle) : ');
  final dateInput = stdin.readLineSync()?.trim() ?? '';

  DateTime? dueDate;

  if (dateInput.isNotEmpty) {
    dueDate = DateTime.tryParse(dateInput);

    if (dueDate == null) {
      throw InvalidTaskException(
        'La date doit être au format YYYY-MM-DD.',
      );
    }
  }

  final id = DateTime.now().millisecondsSinceEpoch.toString();

  final task = priority == Priority.high
      ? UrgentTask(
          id: id,
          title: title,
          dueDate: dueDate,
        )
      : Task(
          id: id,
          title: title,
          priority: priority,
          dueDate: dueDate,
        );

  repository.add(task);

  print('\n✓ Tâche ajoutée avec succès.');
}

Priority parsePriority(String value) {
  switch (value) {
    case 'low':
      return Priority.low;
    case 'medium':
      return Priority.medium;
    case 'high':
      return Priority.high;
    default:
      throw InvalidTaskException(
        'Priorité invalide. Utilisez low, medium ou high.',
      );
  }
}

void listTasks(TaskRepository repository) {
  if (repository.items.isEmpty) {
    print('\nAucune tâche enregistrée.');
    return;
  }

  print('\nTrier les tâches :');
  print('1. Par priorité');
  print('2. Par date');
  print('3. Sans tri');

  stdout.write('Votre choix : ');
  final sortChoice = stdin.readLineSync();

  final tasks = List<Task>.from(repository.items);

  if (sortChoice == '1') {
    tasks.sort(
      (a, b) => b.priority.index.compareTo(a.priority.index),
    );
  } else if (sortChoice == '2') {
    tasks.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) {
        return 0;
      }

      if (a.dueDate == null) {
        return 1;
      }

      if (b.dueDate == null) {
        return -1;
      }

      return a.dueDate!.compareTo(b.dueDate!);
    });
  }

  print('\n========== TÂCHES ==========');

  for (final task in tasks) {
    final status = task.isCompleted ? '✓' : ' ';

    final date = task.dueDate == null
        ? 'Aucune'
        : task.dueDate!.toIso8601String().split('T').first;

    print(
      '[$status] ${task.id} | '
      '${task.title} | '
      '${task.priority.name} | '
      '$date',
    );
  }
}

void completeTask(TaskRepository repository) {
  stdout.write('\nID de la tâche : ');
  final id = stdin.readLineSync()?.trim() ?? '';

  repository.complete(id);

  print('\n✓ Tâche marquée comme terminée.');
}

void deleteTask(TaskRepository repository) {
  stdout.write('\nID de la tâche : ');
  final id = stdin.readLineSync()?.trim() ?? '';

  repository.delete(id);

  print('\n✓ Tâche supprimée.');
}